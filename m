From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] ip_queue memory leaks
Date: Sun, 27 Apr 2003 17:38:04 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427.173804.13764775.davem@redhat.com>
References: <20030427094949.GF990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: mulix@mulix.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030427094949.GF990@sunbeam.de.gnumonks.org>
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
   Date: Sun, 27 Apr 2003 11:49:49 +0200

   Please apply the following patch (courtesy of Muli Ben-Yehuda).
   It fixes memory leaks in the ip_queue code for ipv4 and ipv6.
   
   Patch applies cleanly (-p0) to 2.4.21-rc1 and 2.5.68.
   
Applied to both trees, thanks.
