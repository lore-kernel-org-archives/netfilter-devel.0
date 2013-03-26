From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: [PATCH 3/3 nfacct] user space executable changes and additions
Date: Tue, 26 Mar 2013 20:26:58 +0000
Message-ID: <51520492.9000301@googlemail.com>
References: <514D9D86.9040909@googlemail.com> <20130323152759.GB4925@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33371 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3CZU1X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:27:23 -0400
Received: by mail-la0-f46.google.com with SMTP id fq12so14406097lab.19
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2013 13:27:21 -0700 (PDT)
In-Reply-To: <20130323152759.GB4925@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello again Pablo,


>> * nfacct.c almost completely rewritten
> 
> First off, this huge patchset need to be splitted into smaller logical
> chunks, including a description of why every change you propose needs
> to be done. Several things have been rewritten with no justification
> and this makes harder to focus on reviewing the new feature you want
> to add.
Some of the (small) fixes/features added I can easily split up (the zero-string checking is a good example of that), but some other features/bug fixes isn't that easy to split up because they are interdependent. Take the new restore for example - it needs the new "save", which in turn needs the fmt and the new libnfnetlink_acct functions to be implemented also. It is not easy...

> Bugfixes should always come first. Please, point to bugs and I'll be
> happy to post patches to fix them or simply send me patches if you
> like.
Duly noted.

>> * a bug fixes for the 'add', 'change' and 'delete' commands have been
>>   implemented. Previously, it was possible for a zero-sized account object
>>   name to be added to the accounting table, which was completely useless
>>   since the nfacct match from iptables was preventing the addition of such
>>   object (and rightly so).
> 
> Good catch. But this checking happen in kernel-space, it should reject
> with -EINVAL.
Haha! I've missed this, and you were quick to correct it in the kernel!


>> +#include "nfacct_list.h"
>> +#include "nfacct_utils.h"
>> +
>> +struct nfa {
>> +	struct nfacct *nfacct;
>> +	struct nfacct_list_head head;
>>  };
> 
> Why not use the existing object we have for this in the library?
You mean nfacct? I need this struct to be a linked list, hence why I make an overlay with the new 'head' field.

>> +/* xml header & footer strings */
>> +#define XML_HEADER 	"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" \
>> +			"<nfacct>\n"
>> +#define XML_FOOTER	"</nfacct>\n"
> 
> This seems a cleanup to me. Should come in a different patch.
Noted.

>> +/* main command 'menu' */
>> +static const struct cmd {
>> +	const char *cmd;
>> +	int (*func)(int argc, char **argv);
>> +} cmds[] = {
>> +	{ "list", 	nfacct_cmd_list },
>> +	{ "add",	nfacct_cmd_add },
>> +	{ "delete",	nfacct_cmd_delete },
>> +	{ "get",	nfacct_cmd_get },
>> +	{ "flush",	nfacct_cmd_flush },
>> +	{ "save",	nfacct_cmd_save },
>> +	{ "restore",	nfacct_cmd_restore },
>> +	{ "version",	nfacct_cmd_version },
>> +	{ "help",	nfacct_cmd_help },
>> +	{ 0, 0 }
>> +};
> 
> These generalization is also a code refactorization, should come in a
> separated patch...
I prefer to call them 'enhancements'. Noted though...


>> @@ -185,41 +276,64 @@ static int nfacct_cmd_list(int argc, char *argv[])
>>  
>>  	nl = mnl_socket_open(NETLINK_NETFILTER);
>>  	if (nl == NULL) {
>> -		nfacct_perror("mnl_socket_open");
>> -		return -1;
>> +		RET_ERR("mnl_socket_open");
>>  	}
>>  
>>  	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
>> -		nfacct_perror("mnl_socket_bind");
>> -		return -1;
>> +		RET_ERR("mnl_socket_bind");
>>  	}
>>  	portid = mnl_socket_get_portid(nl);
>>  
>>  	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
>> -		nfacct_perror("mnl_socket_send");
>> -		return -1;
>> +		RET_ERR("mnl_socket_send");
>>  	}
>>  
>> -	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
>> -	while (ret > 0) {
>> -		ret = mnl_cb_run(buf, ret, seq, portid, nfacct_cb, &xml);
>> -		if (ret <= 0)
>> +	options = nfacct_options_alloc();
>> +	if (options == NULL) {
>> +		RET_ERR("OOM");
>> +	}
>> +	nfacct_option_set_u32(options, NFACCT_OPT_FMT, fmt);
>> +
>> +	i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
>> +	while (i > 0) {
>> +		i = mnl_cb_run(buf, i, seq, portid, nfacct_cb, &xml);
>> +		if (i <= 0)
>>  			break;
>> -		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
>> +		i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
> 
> For example, we get nothing with this change above.
We do Pablo - "ret" holds the default value for "error" return code (-1), which is only set at 0 at the very end when everything has been successful. If I use "ret" instead of "i" above, then this will be broken.

> 
>>  	}
>> -	if (ret == -1) {
>> +	if (i == -1) {
> 
> Same thing here, like in several other places of the patch.
See the above comment.

>> +	nfacct_list_for_each_entry(nfa, &nfa_list, head) {
>> +		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
>> +				nfa->nfacct,
>> +				NFACCT_SNPRINTF_T_PLAIN,
>> +				NFACCT_SNPRINTF_F_SAVE, options);
>> +		printf("%s\n",buf);
> 
> It seems the output format of this has changed. This breaks backward
> compatibility for existing users.
It is only problematic when new nfacct is used against old libnfnetlink_acct and even in such a case it gives an error message that new version of libnfnetlink_acct is needed. My initial intention was to bump LIBVERSION since we are adding new functions to the base interface and then change the configure to check for that dependency, but I didn't know whether you will be happy with that, so I left it out for the time being.

If you would like me to do that, the configure from the new nfacct will ask for the appropriate version of libnfnetlink_acct to be installed and the problem will go away (as I already stated, there is no problem if old nfacct is used against new libnfnetlink_acct - this is already taken care of). Let me know whether you are happy for me to do that...

>> +++ b/src/nfacct_list.h
> 
> All netfilter user-space code uses linux_list, it should be converted
> to those.
I realized that, but was getting a compile warning from my gcc (Thomas Graf knows about this), so I had to change this revision to a custom-made one. I'll revert to linux_list for the next submission then.
