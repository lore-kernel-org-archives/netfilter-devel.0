From: Tomas Szepe <szepe@pinerecords.com>
Subject: Re: [PATCHSET] Multiarch kconfig cleanup
Date: Thu, 2 Jan 2003 22:31:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030102213155.GF17053__3286.34918337247$1041618061@louise.pinerecords.com>
References: <20030102182038.GZ17053@louise.pinerecords.com> <Pine.LNX.4.44.0301021152350.3665-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jgarzik@pobox.com, zaitcev@redhat.com, davem@redhat.com,
	linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, netfilter-devel@lists.samba.org,
	phillim2@comcast.net, rmk@arm.linux.org.uk
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Linus Torvalds <torvalds@transmeta.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0301021152350.3665-100000@home.transmeta.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> [torvalds@transmeta.com]
>
> > This is the first time I'm trying to get more than 3 people to work
> > together so I'd be grateful if you didn't kick me too hard should I have
> > screwed up.
> 
> I'd really like to see the organizational patches first (ie the 
> net/Kconfig type of changes), and leave the "conditional menu" patches for 
> later, especially as they would seem to be improved by an extension to the 
> config language (ie the "menucond" thing).
> 
> Also, I don't fetch patches, I'd much rather just be mailbombed.

In a minute, I'm sending the organizational stuff rediffed,
that's patches 15-36 from the original batch as 1-22.  I'll
only send to Linus & CC lkml.

-- 
Tomas Szepe <szepe@pinerecords.com>
