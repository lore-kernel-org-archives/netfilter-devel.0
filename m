From: Brent Clark <brentgclarklist@gmail.com>
Subject: Re: POM Xtables???
Date: Tue, 19 Aug 2008 13:35:01 +0200
Message-ID: <48AAAFE5.10201@gmail.com>
References: <935fab200806271054oa7c340evbf465b7a9984498b@mail.gmail.com>	 <935fab200806300904rc7dc7b2kf58ab7893c3ef20a@mail.gmail.com>	 <486907EA.60105@trash.net>	 <alpine.LNX.1.10.0806302218500.30639@fbirervta.pbzchgretzou.qr>	 <48694787.3080906@trash.net>	 <alpine.LNX.1.10.0807010907040.26892@fbirervta.pbzchgretzou.qr>	 <4887BCE0.2050902@trash.net>	 <38bcb3ec0807240131n1f5d4051k9e89731aa2fcb6c9@mail.gmail.com>	 <488849A5.6050401@netfilter.org> <48884ED3.8080901@trash.net> <38bcb3ec0808150117n729cb7b1yadcfa9018b9714be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	Dave <finalglide@gmail.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <38bcb3ec0808150117n729cb7b1yadcfa9018b9714be@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

James King wrote:
> ipp2p and l7filter both use different strategies for DPI
> classification, each having their own pros and cons.
You know most people, groups etc look for the next best thing. Take a 
look at Firefox and apple ( *pod), they continuously announcing whats 
hip and new, what they doing etc, and looking at ways to keep a captive 
audience.

My question is what netfilters next best thing?

Having used and using Xtables, I thinking it FSCKING brilliant (excuse 
slander, hope I did not offend, but there was not other way to explain). 
I dont have to struggle and my turn around time is minutes.
I continuously thank Jan for the work his doing.

I suggest forget POM. its old and the process is slow and laborious (and 
thats hoping you can get it compiled in the kernel).

Getting back to iptables.

Its great to see others stepping forward and wanting to implement a 
Layer 7 filtering, and I say go for it and work on it, but in the mean 
time and to the netfilter team, my question is, how long will that take 
till its able to get off the ground to too hope that it gets accepted by 
the teams (netfilter and kernel).

To be constructive, and looking for a solid way forward (even if 
interim), would it not be better to implement l7 in xtables or better 
iptables.
Yes the L7 code may suck now or incorrectly thoughtout, but getting it 
working will help people. People understand that its not perfect or bug 
less, the fact they have option and it being worked on, helps.

Im of the opinion that Netfilter really needs to look and think out the 
box and realize ppl want *now*, troubleless (less not free), shiny and 
new (this goes hand in hand with promoting, marketing etc).
Google for pf vs iptables, and you will find a plethora of links 
promoting either / or. Netfilter needs that "shiny" that will set it 
apart from the rest that will and have the bells and whistles.

My aim it to not offend anyone, but let the powers that be know, that 
there is a demand for more. Ill probably get flamed, but I hope this 
email gets taken in the light of constructive criticism and for the 
greater of the user community that like quick install, all in one solution.

Kind Regards
Brent Clark

P.s. James, I hope you get your solution off the ground  and working.







