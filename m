From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: Memory leaks in ip_conntrack?
Date: Tue, 11 Nov 2003 14:24:50 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311111424150.16497-100000@filer.marasystems.com>
References: <7C9884991ADAE0479C14F10C858BCDF52E37C7@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Alistair@nerdnet.ca, Kishore Dharmavaram <kishored@servgate.com>,
   <netfilter@lists.netfilter.org>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF52E37C7@alderaan.smgtec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Mon, 10 Nov 2003, Daniel Chemko wrote:

> Ack! (slaps head)
> 
> I was a victim of this! I finally have a reason for all those annoying
> TCP window error messages! Who knows, I may actually have 'traffic'
> through my gateway at this rate.

tcp_wmem should not be related to forwarded traffic at all, only for local 
TCP sockets..

Regards
Henrik
