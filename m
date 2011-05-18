From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 07/11] libipt_DNAT: use guided option parser
Date: Wed, 18 May 2011 16:17:48 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105181612560.25276@frira.zrqbmnf.qr>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de> <1305121977-4361-8-git-send-email-jengelh@medozas.de> <20110518135819.GA19013@lutz.bln.innominate.local> <alpine.LNX.2.01.1105181600060.25276@frira.zrqbmnf.qr>
 <20110518140536.GA21298@lutz.bln.innominate.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Lutz Jaenicke <ljaenicke@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42281 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1ERORt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 10:17:49 -0400
In-Reply-To: <20110518140536.GA21298@lutz.bln.innominate.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-05-18 16:05, Lutz Jaenicke wrote:

>On Wed, May 18, 2011 at 04:00:56PM +0200, Jan Engelhardt wrote:
>> On Wednesday 2011-05-18 15:58, Lutz Jaenicke wrote:
>> 
>> >> +	case O_TO_DEST:
>> >> +		if (cb->xflags & F_TO_DEST) {
>> >>  			if (!kernel_version)
>> >>  				get_kernel_version();
>> >>  			if (kernel_version > LINUX_VERSION(2, 6, 10))
>> >>  				xtables_error(PARAMETER_PROBLEM,
>> >>  					   "Multiple --to-destination not supported");
>> >>  		}
>> >> -		*target = parse_to(optarg, portok, info);
>> >> +		*cb->target = parse_to(cb->arg, portok, info);
>> >>  		/* WTF do we need this for?? */
>> >> -		if (*flags & IPT_DNAT_OPT_RANDOM)
>> >> +		if (cb->xflags & F_RANDOM)
>> >>  			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
>> >> -		*flags |= IPT_DNAT_OPT_DEST;
>> >> -		return 1;
>> >
>> >If I understand the logic correctly, cb->xflags will have F_TO_DEST set
>> >if the --to-destination option is found. The additional option parsing
>> >is only performed afterwards such that the (cb->xflags & F_TO_DEST) will
>> >be triggered already on the first and valid call and a "Multiple ... not
>> >supported" will be issued.
>> 
>> Fixed by my most recent submission (run 8), f25b235.
>
>I see. I was working against the git repo...

If it is my repo, that should work.

Live maintainers for upstream iptables seem to have run out 
(in either sense) for the moment.
