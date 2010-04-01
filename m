From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Thu, 1 Apr 2010 14:05:37 +0200
Message-ID: <20100401120536.GF19153@mail.eitzenberger.org>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com> <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr> <4BB22952.2050305@trash.net> <n2yfaefb3f11003310647uef53fd2k518c4c8f0367adc5@mail.gmail.com> <4BB473CB.5030300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roman Tsisyk <roman@tsisyk.com>,
	Stig Thormodsrud <stig@vyatta.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	linux-net@vger.kernel.org,
	Holger Eitzenberger <heitzenberger@astaro.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BB473CB.5030300@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

(replying by private mail)

Hi,

> > Thank you for pointing it out, I didn't know about conntrack support in ulogd.
> > 
> > As far as I understood, IPFIX output in ulogd is in a early stage and
> > don't work. So, I tested ulogd + ctnetlink with null output and it
> > worked very well.

I've done an IPFIX implementation a few months ago for ulogd2, but it
currently is of prototype character only, as it only implements IPFIX
over UDP, but SCTP and possibly TCP (+ SSL) are required for a
conforming implementation.  I use the "bi-flow" approach of RFC 51303,
but it shouldn't be a problem at all to have it support the single
direction flow approach instead from RFC 5101/5102.

In general ctnetlink is not a problem here from a performance standpoint,
and I think there is no need for doing that in kernel space.

Some bits and pieces may be missing on the kernel side if you need to
classify your flows though.  E. g. some IPFIX Aggregrators require the
DSCP value for that.

> Accounting is done in kernel space by conntrack, but aggregation should
> be done in userspace in my opinion. I don't think you need a lot of
> optimization, AFAIK Holger's patches already scale to large setups
> very well.

I have setups with hundreds of thounsands of flows, and it accounts
quite well :).

Hope that helps a bit.

 /holger


