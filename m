From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: Re: runme
Date: Tue, 6 Jan 2004 20:52:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002a01c3d48e$98254610$0e25fe0a@southpark.ae.poznan.pl>
References: <Pine.LNX.4.58L.0401061514080.17738@gandalf.uznam.net.pl> <20040106191122.GG934@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > Solution is simple - changing #!/bin/sh into #!/bin/bash and everything 
> > should be fine. I don't know if I should to report it at 
> > bugs.netfilter.org or maybe someone can commit a change to CVS?
> thanks, I'll fix it in CVS.  but normally bugzilla would be the right
Harald, I remember that changing to /bin/sh was part of a wave of
removing bash'isms from the scripts. Not every linux box has bash,
and some people were complaining about it I think.

I do not know if it is relevant, but it might be.

Regards,
Maciej
