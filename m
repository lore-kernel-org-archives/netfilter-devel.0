From: Phil Oester <kernel@linuxace.com>
Subject: Verdict on deadlocks
Date: Tue, 20 Jul 2004 17:09:31 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040721000931.GA3215@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Just a heads up that my gateways, which used to deadlock every 2-3 days are now
stable, and have been running solidly for 2-3 weeks.  This is on 2.6.7, after
applying two patches.  The first is already included in 2.6.8-rcx, and is
the tcp-option bug described here:

http://www.netfilter.org/security/2004-06-30-2.6-tcpoption.html

The second is Patrick McHardy's FTP locking fix, documented here:

http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015719.html

Hopefully the FTP locking patch will be forwarded for inclusion in mainline
soon.  Patrick?


Phil Oester
