From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: extra/pptp-conntrack-nat.patch
Date: Mon, 31 Mar 2003 14:44:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E883849.3050706@fl.priv.at>
References: <3E8832B4.8030901@fl.priv.at> <20030331123134.GN7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030331123134.GN7718@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> 
> actually, _with_ the '//' in front, it accepts packets with broken
> checksums.  If you remove the '//' in front, it will not consider
> packets with broken checksums.
> 
> So W2k should work with the shipped patch ! (IIRC, it works in both
> cases)
> 

So I conclude that there is not a W2k at the other side (I missinterpreted
the comment ion the patch the other way round) because I needed to remove
the '//' to get it working. But when I ask the people what they've got
as PPTP-Server they tell me it's a W2k server.

I'm using the patch that's in pom-20030107. Could that make a difference?

As a side note, I do the following:
  PPTP-Client --> Devil-Linux-Firewall -->...Internet....--> PPTP-Server

At least it works now but it looks like a mistery now.

-- 
MfG / Regards
Friedrich Lobenstock
