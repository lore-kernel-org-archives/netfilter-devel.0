From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: extra/pptp-conntrack-nat.patch
Date: Tue, 01 Apr 2003 21:37:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E89EA96.3040804@fl.priv.at>
References: <3E8832B4.8030901@fl.priv.at> <20030331123134.GN7718@sunbeam.de.gnumonks.org> <3E883849.3050706@fl.priv.at> <20030331130715.GR7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030331130715.GR7718@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

Harald Welte wrote:
> On Mon, Mar 31, 2003 at 02:44:57PM +0200, Friedrich Lobenstock wrote:
>>So I conclude that there is not a W2k at the other side (I missinterpreted
>>the comment ion the patch the other way round) because I needed to remove
>>the '//' to get it working. But when I ask the people what they've got
>>as PPTP-Server they tell me it's a W2k server.
>>
>>At least it works now but it looks like a mistery now.
> 
> 
> indeed. can anybody else on the mailinglist confirm this observation?
> 

So what do you think of making this a module option?
eg.
   modprobe ip_conntrack_pptp braindead_w2k=[0|1]
or
   modprobe ip_conntrack_pptp accept_bad_csum=[0|1]

-- 
MfG / Regards
Friedrich Lobenstock
