From: kilobug@freesurf.fr (=?iso-8859-1?q?Ga=EBl_Le_Mignot?=)
Subject: Re: Call for testing: patch-o-matic-ng
Date: Tue, 23 Dec 2003 14:13:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <plopm3zndjoexg.fsf@drizzt.kilobug.org>
References: <20031221122445.GC5058@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031221122445.GC5058@obroa-skai.de.gnumonks.org> (Harald
 Welte's message of "Sun, 21 Dec 2003 13:24:45 +0100")
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,

I've tested pom-ng on 2.6.0  with USAGI patch, the patch-o-matic seems
to work, but the kernel doesn't compile (I put nearly all patches, and
select M in the kernel config wherever it was possible):

  CC      net/core/netfilter.o
net/core/netfilter.c: In function `nf_log_register':
net/core/netfilter.c:760: warning: implicit declaration of function `br_write_lock_bh'
net/core/netfilter.c:760: error: `BR_NETPROTO_LOCK' undeclared (first use in this function)
net/core/netfilter.c:760: error: (Each undeclared identifier is reported only once
net/core/netfilter.c:760: error: for each function it appears in.)
net/core/netfilter.c:765: warning: implicit declaration of function `br_write_unlock_bh'
net/core/netfilter.c: In function `nf_log_unregister':
net/core/netfilter.c:770: error: `BR_NETPROTO_LOCK' undeclared (first use in this function)
make[3]: *** [net/core/netfilter.o] Error 1


I think maybe some patches doesn't work with 2.6, would it possible to
add a way to select patch that works with 2.6 ? like ./runme extra-2.6
or such ?

-- 
Gael Le Mignot "Kilobug" - kilobug@nerim.net - http://kilobug.free.fr
GSM         : 06.71.47.18.22 (in France)   ICQ UIN   : 7299959
Fingerprint : 1F2C 9804 7505 79DF 95E6 7323 B66B F67B 7103 C5DA

Member of HurdFr: http://hurdfr.org - The GNU Hurd: http://hurd.gnu.org
