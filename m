From: Patrick McHardy <kaber@trash.net>
Subject: Re: lots of oopses
Date: Tue, 22 Aug 2006 01:09:02 +0200
Message-ID: <44EA3D0E.1030307@trash.net>
References: <44E49911.6080007@ufomechanic.net> <44E4A1AB.3000001@trash.net>
	<44E56D39.50806@ufomechanic.net> <44E605A1.5000007@trash.net>
	<44E6C247.9010704@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44E6C247.9010704@ufomechanic.net>
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

Amin Azez wrote:
> Patrick McHardy wrote:
> 
>> Unfortunately ebtables is in large parts a copy of iptables, with just
>> enough differences to prevent it from using x_tables.
> 
> Hmm, now I'm interested, what are the problematic differences?

Mostly slightly different structure layout.
