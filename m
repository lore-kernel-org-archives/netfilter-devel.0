From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_owner
Date: Sat, 20 Oct 2007 17:52:55 +0200
Message-ID: <471A2457.5030008@trash.net>
References: <Pine.LNX.4.64.0710201345230.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34420 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbXJTPxz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:53:55 -0400
In-Reply-To: <Pine.LNX.4.64.0710201345230.1997@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Convert ipt_owner to xt_owner, adding support for IPv6.
>
> +struct xt_owner_info {
> +	u_int32_t uid;
> +	u_int32_t gid;
> +	u_int8_t match, invert;
> +};

Unfortunately this also breaks compatiblity, we currently have:

struct ipt_owner_info {
    uid_t uid;
    gid_t gid;
    pid_t pid;
    pid_t sid;
    char comm[16];
    u_int8_t match, invert;     /* flags */
};

and

struct ip6t_owner_info {
    uid_t uid;
    gid_t gid;
    pid_t pid;
    pid_t sid;
    u_int8_t match, invert;     /* flags */
};

This is compatible with neither one.
