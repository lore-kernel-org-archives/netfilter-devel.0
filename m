From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Fri, 16 Mar 2007 14:00:15 +0100
Message-ID: <45FA94DF.9040700@trash.net>
References: <200703020946.20765.thomas.jarosch@intra2net.com>
	<200703151804.21980.thomas.jarosch@intra2net.com>
	<45FA17BC.7050405@trash.net>
	<200703161352.45433.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703161352.45433.thomas.jarosch@intra2net.com>
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
> Thanks. Would it be possible as a short term solution from an internal 
> infrastructure point of view to write a "dummy" helper which
> does nothing except registering itself as helper?
> 
> As far as I can see the dummy helper would have to "listen" on TCP port 1080
> to own all conntracks to the socks server. Then it should be possible
> to add expectations to these conntracks, right?


Yes, that should work fine.
