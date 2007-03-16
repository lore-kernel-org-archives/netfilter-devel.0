From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Fri, 16 Mar 2007 05:06:20 +0100
Message-ID: <45FA17BC.7050405@trash.net>
References: <200703020946.20765.thomas.jarosch@intra2net.com>
	<45F04F6F.5020103@trash.net>
	<200703091138.57392.thomas.jarosch@intra2net.com>
	<200703151804.21980.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703151804.21980.thomas.jarosch@intra2net.com>
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

Thomas Jarosch wrote:
> Could you take a shot at the helperless expectation, please?
> I would happily test it :-)

I'm currently busy with a few other things, but I'll try to
look into it in the next time. Might take a bit longer than
I initially estimated though, since this will be exposed to
userspace and is also needed for userspace-helpers I want to
make sure its really what we need.
