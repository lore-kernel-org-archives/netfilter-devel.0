From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] ip_conntrack_ftp.c: cosmetic typo fix in debug macro
Date: Fri, 10 Jan 2003 00:58:57 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110.005857.74817368.davem@redhat.com>
References: <20030109145154.GL9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20030109145154.GL9467@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Harald Welte <laforge@gnumonks.org>
   Date: Thu, 9 Jan 2003 15:51:54 +0100

   Author: Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
   Cosmetic Fix:
   Fixes a typo in a DEBUG statement (which is contained in an "#if 0" block,
   so this would never end up causing a problem).  

Applied, thanks.
