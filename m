From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] multiple 2.4.x ipt_REJECT fixes
Date: Sun, 27 Apr 2003 17:45:33 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427.174533.58445179.davem@redhat.com>
References: <20030427104603.GJ990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030427104603.GJ990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Harald Welte <laforge@netfilter.org>
   Date: Sun, 27 Apr 2003 12:46:03 +0200

   Again another patch, courtesy of Patrick McHardy.  This time a 2.4.x
   only patch (applies against 2.4.21-rc1).  The fix is incremental to a
   change in early 2.4.21-preX days.
   
   Please apply, Thanks

Applied, and I retrofitted the fixes into 2.5.x
On the 2.5.x side, I had fixed the tcp-rst routing inadvertantly
during the IPSEC routing changes :-)
