From: Phil Oester <kernel@linuxace.com>
Subject: Enhanced multiport match into mainline?
Date: Tue, 24 Aug 2004 09:40:57 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040824164057.GA4767@linuxace.com>
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

Any reason why this pom patch hasn't been pushed to mainline?

Today, I have quite a few instances of:

-m multiport --dport 21,80,443
--dport 1024:

which would be nice if I could consolidate into

-m multiport --dport 21,80,443,1024:

Something holding this back?

Phil
