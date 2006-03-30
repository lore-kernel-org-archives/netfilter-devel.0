From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Hashtrie testing2, dancing trees
Date: Thu, 30 Mar 2006 09:28:40 +0100
Message-ID: <442B96B8.4080405@ufomechanic.net>
References: <43EFF1F0.1090701@netfilter.org>	<20060213112028.GU4601@sunbeam.de.gnumonks.org>	<43F438F5.8070607@trash.net>	<Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>	<43F43FA9.4000906@trash.net>	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>	<43F4426D.9060807@trash.net>	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>	<43F4DBDF.9010008@trash.net>	<Pine.LNX.4.58.0602170907001.29301@blackhole.kfki.hu>	<Pine.LNX.4.58.0602170936160.1339@tux.rsn.bth.se>	<Pine.LNX.4.58.0602170951070.29301@blackhole.kfki.hu>	<1141503111.3881.61.camel@localhost.localdomain>	<Pine.LNX.4.58.0603051049470.28988@blackhole.kfki.hu>	<1141580938.3881.129.camel@localhost.localdomain>	<Pine.LNX.4.58.0603061125280.29731@blackhole.kfki.hu>
	<1141756438.3881.158.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1141756438.3881.158.camel@localhost.localdomain>
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

Just for interest, and I don't know how well tuned for processor cache 
it is, but Hans Reisers dancing trees are build to solve some of this 
problem; dancing trees keep themselves balanced.

I realise that filesystem timescales are not the same as packet 
processing timecales, I merely mention it for completeness.

Sam
