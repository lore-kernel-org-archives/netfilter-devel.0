From: snpe <snpe@snpe.co.yu>
Subject: Re: 2.4.23 masquerading broken?
Date: Tue, 2 Dec 2003 20:18:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200312022018.03078.snpe@snpe.co.yu>
References: <20031202165653.GJ615@gaast.net> <3FCCCB02.5070203@trash.net> <20031202173358.GK615@gaast.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Wilmer van der Gaast <lintux@lintux.cx>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <20031202173358.GK615@gaast.net>
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

It work for me
(2.4.23 with linux abi, gcc 3.2 from RedHat 8.0 - netfilter like modules)
regards
Haris Peco
On Tuesday 02 December 2003 05:33 pm, Wilmer van der Gaast wrote:
> Patrick McHardy (kaber@trash.net) wrote:
> > Can you check the ringbuffer for error messages ? What happens
> > to the packets when masquerading fails ?
>
> Hmm. Damn, forgot about the syslogs completely. :-(
>
> Dec  2 16:42:30 tosca kernel: MASQUERADE: Route sent us somewhere else.
> Dec  2 16:42:44 tosca last message repeated 11 times
> Dec  2 16:42:47 tosca kernel: NET: 1 messages suppressed.
> Dec  2 16:42:47 tosca kernel: MASQUERADE: Route sent us somewhere else.
> Dec  2 16:42:51 tosca kernel: NET: 5 messages suppressed.
> Dec  2 16:42:51 tosca kernel: MASQUERADE: Route sent us somewhere else.
> Dec  2 16:42:57 tosca kernel: NET: 4 messages suppressed.
> Dec  2 16:42:57 tosca kernel: MASQUERADE: Route sent us somewhere else.
>
> And, well, it goes on like that. dmesg is full of messages like this.
>
> The packages seem to get lost completely. At least I don't see them
> going out on eth1 (where they should go to).
>
>
> Wilmer van der Gaast.
