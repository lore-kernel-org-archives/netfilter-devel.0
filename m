From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: Fw: [PATCH 2.4.22] looseUDP support
Date: Wed, 14 Apr 2004 18:14:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404141808090.3773-100000@filer.marasystems.com>
References: <7C9884991ADAE0479C14F10C858BCDF56792D4@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: John Ho <john_ho@sh.askey.com.tw>
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF56792D4@alderaan.smgtec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 14 Apr 2004, Daniel Chemko wrote:

> Loose UDP is a dynamicly sending UDP packets to machines behind the
> firewall instead of openning ports accordingly.

Sort of automatic "last resort" port forwarding based on who was using the
nework last then?

Primary reason I see for such things is to support odd multichannel
protocols for which there is no conntrack helper such as many online
gaming protocols.

If this is what is wanted I would recommend doing it via a custom DNAT 
target implementing dynamic port forwarding rather than mucking around 
with the NAT core expectaions of UDP sessions.

Regards
Henrik
