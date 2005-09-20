From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: buffer overflow in ip_ct_{ftp,tftp,irc}
Date: Tue, 20 Sep 2005 21:48:21 +0900 (JST)
Message-ID: <200509201248.j8KCmMjv009044@toshiba.co.jp>
References: <432213E5.4000200@trash.net>
	<200509200711.j8K7Bw3x002184@toshiba.co.jp>
	<20050920093510.GB31236@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Sep_20_21_48_21_2005_343)--"
Content-Transfer-Encoding: 7bit
Cc: sbellabes@mandriva.com, yasuyuki.kozakai@toshiba.co.jp,
	netfilter-devel@lists.netfilter.org, davem@davemloft.net,
	kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050920093510.GB31236@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Tue_Sep_20_21_48_21_2005_343)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Harald Welte <laforge@netfilter.org>
Date: Tue, 20 Sep 2005 11:35:10 +0200

> On Tue, Sep 20, 2005 at 04:11:57PM +0900, Yasuyuki KOZAKAI wrote:
> > 
> > From: Patrick McHardy <kaber@trash.net>
> > Date: Sat, 10 Sep 2005 00:59:49 +0200
> > 
> > > > -static int ports[MAX_PORTS];
> > > > +static short ports[MAX_PORTS];
> > > > static int ports_c;
> > > > -module_param_array(ports,int, &ports_c, 0400);
> > > > +module_param_array(ports, short, &ports_c, 0400);
> > > 
> > > I agree, I've applied this patch instead. Thanks.
> > 
> > Why don't you use u_int16_t and ushort instead of short ?
> 
> I tried this first, but the module_parm_* macros only deal with short.

Really ? At least, the current moduleparam.h in David's git tree includes
declarations for param_*_ushort(). And I succeeded to compile and use ftp
module with the attached patch.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Which kernel you tried ?

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Tue_Sep_20_21_48_21_2005_343)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ushort-ftp-ports.patch"

diff --git a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c
@@ -29,9 +29,9 @@ static char *ftp_buffer;
 static DEFINE_SPINLOCK(ip_ftp_lock);
 
 #define MAX_PORTS 8
-static short ports[MAX_PORTS];
+static u_int16_t ports[MAX_PORTS];
 static int ports_c;
-module_param_array(ports, short, &ports_c, 0400);
+module_param_array(ports, ushort, &ports_c, 0400);
 
 static int loose;
 module_param(loose, int, 0600);

----Next_Part(Tue_Sep_20_21_48_21_2005_343)----
