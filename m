From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Fix logging of SIT tunnels in ip6t_LOG
Date: Mon, 14 Oct 2002 04:28:56 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014.042856.34540687.davem@redhat.com>
References: <20021014133050.P13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20021014133050.P13233@sunbeam.de.gnumonks.org>
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
   Date: Mon, 14 Oct 2002 13:30:50 +0200

   Below is a patch (by Andras Kis-Szabo) fixing the ip6tabels LOG
   target in order to correctly display the IPv4 encapsulation when
   SIT is used.

I will apply this to both 2.4.x and 2.5.x, thanks.

On the 2.4.x side, I'd like to defer these netfilter
patches you are sending today until 2.4.21-pre1.
I hope this won't be a huge problem?

I really don't want to contribute to 2.4.20 being delayed further.
:)
