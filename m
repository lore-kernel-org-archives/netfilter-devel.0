From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip_conntrack table full problem
Date: Mon, 21 Mar 2005 19:41:06 +0100
Message-ID: <20050321184105.GA378@oknodo.bof.de>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<200503211513.59943.thomas.jarosch@intra2net.com>
	<20050321162147.GA14696@linuxace.com>
	<200503211803.18918.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Content-Disposition: inline
In-Reply-To: <200503211803.18918.thomas.jarosch@intra2net.com>
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

> Would it be possible to dump the internal conntrack tables
> once the error occurs?

The interface for such dumping is /proc/net/ip_conntrack, where you
only find 35 conntracks in your table-full situation. So I would
strongly doubt that extra "show them all" code would show much
more than that...

Just a random comment - unfortunately I have no idea how to
help more constructively.

best regards
  Patrick
