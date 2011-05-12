From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/8] netfilter: IPv6: initialize TOS field in REJECT target
 module
Date: Thu, 12 May 2011 10:23:03 +0200
Message-ID: <4DCB98E7.4010804@netfilter.org>
References: <1305021959-2980-1-git-send-email-pablo@netfilter.org>	 <1305021959-2980-7-git-send-email-pablo@netfilter.org> <1305090777.5570.7.camel@nexus.oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net
To: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?=
	<fernando@oss.ntt.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55956 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab1ELIWf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 04:22:35 -0400
In-Reply-To: <1305090777.5570.7.camel@nexus.oss.ntt.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/05/11 07:12, Fernando Luis V=C3=A1zquez Cao wrote:
> Hi Pablo,
>
> Thank you for taking care of these patches, I really appreciate it.
>
> I noticed that they have just been picked up by Linus. Could we get t=
hem
> into the -stable and -longterm trees too?
>
> 1ed2f73d90fb49bcf5704aee7e9084adb882bfc5 (netfilter: IPv6: fix DSCP m=
angle code)
> 4319cc0cf5bb894b7368008cdf6dd20eb8868018 (netfilter: IPv6: initialize=
 TOS field in REJECT target module)

OK, I'll pass them to -stable as soon as I find some spare time.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
