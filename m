From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: [PATCHSET] Multiarch kconfig cleanup
Date: Thu, 2 Jan 2003 11:54:17 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0301021152350.3665-100000__9840.21179979227$1041617735@home.transmeta.com>
References: <20030102182038.GZ17053@louise.pinerecords.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jgarzik@pobox.com, <zaitcev@redhat.com>, <davem@redhat.com>,
	<linux-kernel@vger.kernel.org>, <sparclinux@vger.kernel.org>,
	<linux-m68k@lists.linux-m68k.org>, <netfilter-devel@lists.samba.org>,
	<phillim2@comcast.net>, <rmk@arm.linux.org.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tomas Szepe <szepe@pinerecords.com>
In-Reply-To: <20030102182038.GZ17053@louise.pinerecords.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Thu, 2 Jan 2003, Tomas Szepe wrote:
> 
> This is the first time I'm trying to get more than 3 people to work
> together so I'd be grateful if you didn't kick me too hard should I have
> screwed up.

I'd really like to see the organizational patches first (ie the 
net/Kconfig type of changes), and leave the "conditional menu" patches for 
later, especially as they would seem to be improved by an extension to the 
config language (ie the "menucond" thing).

Also, I don't fetch patches, I'd much rather just be mailbombed.

		Linus
