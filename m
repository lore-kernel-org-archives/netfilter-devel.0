From: Max Kellermann <max@duempel.org>
Subject: Re: ip_nat|conntrack_h323.c on 2.6
Date: Tue, 4 Jan 2005 21:25:47 +0100
Message-ID: <20050104202547.GA32108@roonstrasse.net>
References: <20041209193823.GA6216@roonstrasse.net>
	<20041214044823.48201.qmail@web50502.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20041214044823.48201.qmail@web50502.mail.yahoo.com>
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

On 2004/12/14 05:48, Kevin McConnell <kevymac@yahoo.com> wrote:
> I'd say, since nobody replied to it, that if you'd like to undertake
> porting it, that many people on this list (including myself) would
> be pretty greatful if you got working.

I'd like to announce, I am working on the 2.6 port of the CT/NAT H323
module. It's already working, only the NAT part is fragile, mainly
because I havn't understood everything of the CT/NAT API yet.

I'll send a patch as soon as I'm able to tell whether my code is
correct (and as soon as I think it is)...

The "brute force" algorithm is still the same in my port; eventually,
I will improve that later.

Max
