From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Fri, 16 Mar 2007 13:52:45 +0100
Message-ID: <200703161352.45433.thomas.jarosch@intra2net.com>
References: <200703020946.20765.thomas.jarosch@intra2net.com>
	<200703151804.21980.thomas.jarosch@intra2net.com>
	<45FA17BC.7050405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FA17BC.7050405@trash.net>
Content-Disposition: inline
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

Hello Patrick,

On Friday, 16. March 2007, Patrick McHardy wrote:
> > Could you take a shot at the helperless expectation, please?
> > I would happily test it :-)
>
> I'm currently busy with a few other things, but I'll try to
> look into it in the next time. Might take a bit longer than
> I initially estimated though, since this will be exposed to
> userspace and is also needed for userspace-helpers I want to
> make sure its really what we need.

Thanks. Would it be possible as a short term solution from an internal 
infrastructure point of view to write a "dummy" helper which
does nothing except registering itself as helper?

As far as I can see the dummy helper would have to "listen" on TCP port 1080
to own all conntracks to the socks server. Then it should be possible
to add expectations to these conntracks, right?

Cheers,
Thomas
