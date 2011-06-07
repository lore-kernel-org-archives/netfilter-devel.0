From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Mon, 06 Jun 2011 18:23:53 -0700
Message-ID: <4DED7DA9.2000008@schaufler-ca.com>
References: <4DDE9194.4030303@netfilter.org> <4DECD1D8.60804@googlemail.com>	<4DED6143.1050809@netfilter.org> <201106062059.03876.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Thomas Graf <tgraf@redhat.com>,
	Patrick McHardy <kaber@trash.net>, linux-audit@redhat.com,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Eric Paris <eparis@parisplace.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm11-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.124]:39268
	"HELO nm11-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754948Ab1FGBYR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:24:17 -0400
In-Reply-To: <201106062059.03876.sgrubb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6/6/2011 5:59 PM, Steve Grubb wrote:
> On Monday, June 06, 2011 07:22:43 PM Pablo Neira Ayuso wrote:
>> On 06/06/11 15:10, Mr Dash Four wrote:
>>>> Exactly my point. There is no leak if its text or numeric.
>>> No, there is no leak if it is a text, but there *is* a leak if it is a
>>> numeric. I think I've made that quite clear.
>> We don't use numeric secmark anymore in nf_conntrack. Not very familiar
>> with SELinux, but I remember that the convention was not to provide
>> internal numeric values.
> All of the audit system records the numbers if conversion fails.

Consistency is important

> We want it as 
> forensic evidence or troubleshooting information as the case may be.

It's completely pointless to have in the audit record. The code
ought to treat an untranslatable secmark with the same severity
as an invalid pointer. You could argue that it is oopsable. Certainly
worthy of a BUG invocation. Printing the numeric is sloppy error
handling.

> -Steve
>
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit
>

