From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: iptables and SPI...
Date: Fri, 31 Oct 2003 18:41:35 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310311839030.21502-100000@filer.marasystems.com>
References: <Law10-F126ORH9HWP5R0002a333@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: laforge@netfilter.org, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dimitri borjac <dimitri_borjac@hotmail.com>
In-Reply-To: <Law10-F126ORH9HWP5R0002a333@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 31 Oct 2003, dimitri borjac wrote:

> what i'm trying to do is to perform NAT based on IP_addresses/Ports/SPIs.

Why not simply using a IP-Sec implementation supporting the 
NAT-Transversal standard?

IP-Sec is generally not very happy about being NAT:ed. For examle AH is
totally incompatible with NAT (unless using the NAT-Transversal standard).

Regards
Henrik
