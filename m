From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Thu, 01 Apr 2010 16:29:10 +0200
Message-ID: <4BB4ADB6.4080206@netfilter.org>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com> <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr> <4BB22952.2050305@trash.net> <n2yfaefb3f11003310647uef53fd2k518c4c8f0367adc5@mail.gmail.com> <4BB473CB.5030300@trash.net> <20100401120536.GF19153@mail.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>, Roman Tsisyk <roman@tsisyk.com>,
	Stig Thormodsrud <stig@vyatta.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	linux-net@vger.kern
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20100401120536.GF19153@mail.eitzenberger.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

Holger Eitzenberger wrote:
> (replying by private mail)
>>> Thank you for pointing it out, I didn't know about conntrack support in ulogd.
>>>
>>> As far as I understood, IPFIX output in ulogd is in a early stage and
>>> don't work. So, I tested ulogd + ctnetlink with null output and it
>>> worked very well.

IPFIX support in ulog2 in the git tree has been indeed
broken/unifinished since long time ago.

> I've done an IPFIX implementation a few months ago for ulogd2, but it
> currently is of prototype character only, as it only implements IPFIX
> over UDP, but SCTP and possibly TCP (+ SSL) are required for a
> conforming implementation.  I use the "bi-flow" approach of RFC 51303,
> but it shouldn't be a problem at all to have it support the single
> direction flow approach instead from RFC 5101/5102.

I've also have one of my internal tree, I started last summer but thesis
has prevent me from working on that.

> In general ctnetlink is not a problem here from a performance standpoint,
> and I think there is no need for doing that in kernel space.

Indeed.

> Some bits and pieces may be missing on the kernel side if you need to
> classify your flows though.  E. g. some IPFIX Aggregrators require the
> DSCP value for that.

We can post a patch to add the missing stuff to ctnetlink.
