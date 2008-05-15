From: Anton <anton.vazir@gmail.com>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 16:04:44 +0500
Message-ID: <200805151604.44874.anton.vazir@gmail.com>
References: <200805151421.23862.anton.vazir@gmail.com> <20080515093413.GC3442@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:37712 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbYEOLEm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 07:04:42 -0400
In-Reply-To: <20080515093413.GC3442@khasse.inl.fr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 15 May 2008 14:34, Eric Leblond wrote:
> Hello,
>
> On Thursday, 2008 May 15 at 14:21:23 +0500, Anton wrote:
> > Regarding the performance of the lookup of the iptables
> > rules for match inside the kernel, is there any plans
> > to improve the behaviour or no plans in this area yet?
>
> Nf hipac is an alternative: http://www.hipac.org/

It looks like there is almost no development, but It would 
be good if i'm wrong 

>
> >
> > Do I miss anything?
>
> If you plan to use mark for QOS or routing why not simply
> use native classifier of tc or "ip rule" ?

Jan meant the exact case, I'm using this for shaper, so I 
would need to remake scripts to use IPMARK... hopefully it 
can also match networks... but this will give inflexibility 
in many cases, like ports

>
> One other thing to look at may be :
> http://www.netfilter.org/projects/patch-o-matic/pom-exter
>nal.html#pom-external-IPMARK
>
> BR,
