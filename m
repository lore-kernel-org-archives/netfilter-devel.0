From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2] Root in namespace owns x_tables /proc entries
Date: Mon, 16 Nov 2015 15:56:13 -0600
Message-ID: <87mvudk3r6.fsf@x220.int.ebiederm.org>
References: <20151114091214.GA486@compaq.slightly-cracked.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org
To: Philip Whineray <phil@firehol.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:59949 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbKPWEY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 17:04:24 -0500
In-Reply-To: <20151114091214.GA486@compaq.slightly-cracked.com> (Philip
	Whineray's message of "Sat, 14 Nov 2015 09:12:14 +0000")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Whineray <phil@firehol.org> writes:

> Reading these files is impossible in an unprivileged user namespace,
> interfering with various firewall tools. For instance, iptables-save
> relies on reading /proc/net/ip_tables_names to dump only loaded tables.
> ---
>
> Please don't apply in current form - it doesn't work. The namespace is
> only set up after the /proc entry is created so it keeps the original
> owner (an unshare within an unshare can work... mapping root to root).
>
> Since it's in danger of getting quite complicate, would one or more of
> the following be acceptable?
>
> - Choose permission in a module parameter
>
> - Allow setting with sysctl e.g. net.netfilter.conf.xtable_proc_perms
>
> - Match permissions of /proc/modules (grsec restricts these so we will
>   gain the same policy).
>
> I also worked on a capabilities patch but that made userspace much more
> complicated in a namespace than outside one. It would be simpler
> to patch programs to read /proc/modules or assume the contents if they
> can't read /proc/net/ip_tables_names.
>
>  net/netfilter/x_tables.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 9b42b5e..671654d 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1227,6 +1227,8 @@ int xt_proto_init(struct net *net, u_int8_t af)
>  #ifdef CONFIG_PROC_FS
>  	char buf[XT_FUNCTION_MAXNAMELEN];
>  	struct proc_dir_entry *proc;
> +	kuid_t root_uid;
> +	kgid_t root_gid;
>  #endif
>  
>  	if (af >= ARRAY_SIZE(xt_prefix))
> @@ -1234,12 +1236,16 @@ int xt_proto_init(struct net *net, u_int8_t af)
>  
>  
>  #ifdef CONFIG_PROC_FS
> +	root_uid = make_kuid(current_user_ns(), 1000);
> +	root_gid = make_kgid(current_user_ns(), 1000);

These lines are wrong.  They should be:

	root_uid = make_kuid(net->user_ns, 0);
        root_gid = make_kgid(net->user_ns, 0);
        if (!uid_valid(root_uid) || !gid_valid(root_gid))
        	goto out;

>  	strlcpy(buf, xt_prefix[af], sizeof(buf));
>  	strlcat(buf, FORMAT_TABLES, sizeof(buf));
>  	proc = proc_create_data(buf, 0440, net->proc_net, &xt_table_ops,
>  				(void *)(unsigned long)af);
>  	if (!proc)
>  		goto out;
> +	proc_set_user(proc, root_uid, root_gid);
>  
>  	strlcpy(buf, xt_prefix[af], sizeof(buf));
>  	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
