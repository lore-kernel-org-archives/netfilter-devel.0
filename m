From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables-addons 1.6
Date: Wed, 19 Nov 2008 09:05:19 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811190900450.24370@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0811181840170.2316@fbirervta.pbzchgretzou.qr> <7259d7020811181620n1ca06f84oe9d6d1f5f0a680c7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: JC Janos <jcjanos245@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <7259d7020811181620n1ca06f84oe9d6d1f5f0a680c7@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Wednesday 2008-11-19 01:20, JC Janos wrote:
>On Tue, Nov 18, 2008 at 9:42 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> which incorporates a newer version of ipset (after the many releases it
>> did ;-)
>
>If we already have built & installed the latest ipset from its svn:
>repository is it ok to use it instead?

Yes - your choice.

You only really need to be aware that `make install` may overwrite an
existing ipset (specifically the binary and manpage).

>Can the xtables-addons build be informed of a preexisting ipset?
>'configure --help' doesn't seem to have an option for it.

Yes, you can edit the "mconfig" file and set "build_ipset=n".
