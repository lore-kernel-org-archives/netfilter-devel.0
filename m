From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Add C99 initializers to net/ipv4/netfilter
Date: Thu, 20 Mar 2003 00:41:14 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030320.004114.54066329.davem@redhat.com>
References: <20030316202820.GA9134@debian>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ahaas@airmail.net
In-Reply-To: <20030316202820.GA9134@debian>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Art Haas <ahaas@airmail.net>
   Date: Sun, 16 Mar 2003 14:28:20 -0600
   
   Here is a set of patches converting more structures to use C99
   initializers. The patches are against the current BK. A set of
   similar patches for the ipv6 code will follow. These patches also
   include an occasional removal of a '.maxlen = 0,' line in the
   initializers.

Applied, thanks Art.
