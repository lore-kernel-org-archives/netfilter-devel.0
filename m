From: Patrick Schaaf <bof@bof.de>
Subject: Re: Personal Firewall
Date: Mon, 4 Nov 2002 11:17:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021104101704.GF3894@oknodo.bof.de>
References: <20021102185357.44537.qmail@web40106.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: moath abdullah <moath2@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20021102185357.44537.qmail@web40106.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello moath abdullah,

a small formal critique first: please format your lines explicitly
to be shorter than about 75 characters. This makes it a lot easier
for readers and responders to reference your questions. I'll reformat
while replying, as neccessary...

> The most important features are :

I'll answer them in a different order.

> 2- to give the user the ability to immediately disconnect from the
> internet when he sees something strange.

This is easy:
- give them a button
- make the button change to appropriate permissions (you need root)
- flush all iptables tables where appropriate, set default policies
  to drop.
- maybe shutdown the bazillion of different network interfaces
  (hang up that modem, now)

At the second step, you will hopefully learn all about Unix security.
If not, please make this your personal small project, and never let
it out in the wild.

> 1- to listen on all ports and try to catch any service i.e. deamon
>trying to connect to network and ask the user if he trusted this
>deamon to act as either client or server.

Careful here. Normally, 'listen' means accepting _incoming_ TCP connection
attempts. A local daemon making outgoing connections does not listen,
it 'connects'. Just some terminology... I think by writing 'client or
server', you tell us you want to cover both situations.

Are you aware that this means intercepting and interpreting every
TCP connection your user's web browser makes? i.e. about 20 to 30
intercepts for each new page displayed to the user?

> The first thing I want to ask about is can I use iptables and its rules
> to implement these especially the first feature?

iptables rules can do one thing for you. Using the nat table REDIRECT
target at PREROUTING, INPUT and OUTPUT, you can direct all TCP connections
towards a local user level transparent proxy process. This must be part
of YOUR software. A special system call (search for SO_ORIGINAL_DEST
on google) gives your software the real destination the connection was
supposed to go to.

> The second question is if the answer of the first is no can I use the source
> code of the iptables to make it trigger an event when it listens to a new
> port (i.e. a deamon trying to get on the network) instead of rejecting it?

You do not use the sourcecode of iptables. You use the iptables executable
(after you magically attained root privilege), and you use the special call
SO_ORIGINAL_DEST.

Now, at that point, you have the connection. What protocol do you intend
to speak now, your YOUR program? iptables does not implement any protocol
above TCP. That's up to you.

Next comes the question of how you can now do the real connection to
the appropriate destination. iptables, with a simple REDIRECT rule,
will happily direct the attempt back at your own proxy program
(that's what they are called: application level proxies. just google.)

But, I'm sure iptables will have a solution here, which you will
be sure to discover after you managed to correctly accept and
intercept the numerous TCP protocols.

By the way, there is a much better mechanism than REDIRECT in the works.
It won't help you with any of the places in this mail where I talked
about YOUR program, but it will be much nicer for you. It is called
TPROXY. Did I mention asking google about all the strange words, here?
I hope so. :)

With all that hopefully out of the way, you will certainly be aware
that the main body of work will be then:

> 3- to allow the user to constuct a white list for children, education ...

It is totally up to YOUR program to implement that (for whatever one of
the gazillion protocols your software may be told to handle).

iptables does not know about children, or education. iptables does not
even know what the URL is in an HTTP request. This is the job of YOUR
program.

> 4- trying to stop anyone trying getting into the system and inform the
> user about this and also putting this into a log file.

Again, that's up to you to provide.

The GUI will be the easy part (as we systems programmers always say :)

> is it easy for me as a beginner in linux programming :)?

It's an excellent start. In some years, you'll stop being a beginner
in linux programming, if you persist until then.

In parting, let me mention that I sincerely hope you are NOT offended
by the tone of this mail. What you describe is not easy, and it is
very naive of a beginning programmer to tackle it, but then trying
in spite of that position, is a worthy goal. Good learning for you,
however this specific set of questions and desires works out :)

best regards
  Patrick
