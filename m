From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCHSET] Multiarch kconfig cleanup
Date: Thu, 02 Jan 2003 18:10:12 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E14C6D4.1040506__18481.5964232714$1041618127@pobox.com>
References: <Pine.GSO.4.21.0301022358340.6446-100000@vervain.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tomas Szepe <szepe@pinerecords.com>,
	Linus Torvalds <torvalds@transmeta.com>, zaitcev@redhat.com,
	"David S. Miller" <davem@redhat.com>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	sparclinux@vger.kernel.org,
	Linux/m68k <linux-m68k@lists.linux-m68k.org>,
	netfilter-devel@lists.samba.org, phillim2@comcast.net,
	Russell King <rmk@arm.linux.org.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <Pine.GSO.4.21.0301022358340.6446-100000@vervain.sonytel.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Geert Uytterhoeven wrote:
> linux-m68k: Should we kill CONFIG_NE2K_ZORRO, or kill CONFIG_ARIADNE2 and
> rename the driver to ne2k-zorro.c?

I'm not linux-m68k, but let me add my small voice in preference to the 
latter, using ne2k-zorro as the name across the board.

If I had my druthers, I would s/pcnet_cs/ne2k_cs/ too...  hmmmmmm  :)
