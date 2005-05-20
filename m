From: cranium2003 <cranium2003@yahoo.com>
Subject: Re: IP packet logging  function help
Date: Fri, 20 May 2005 05:41:42 -0700 (PDT)
Message-ID: <20050520124142.88156.qmail@web33001.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter <netfilter-devel@lists.netfilter.org>,
	netfilterusers <netfilter@lists.netfilter.org>
In-Reply-To: 6667
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

hello,
       Sorry i was hurry to know how to do what i want
by reading
> > >Because, in some table it is simply not yet
> > > determined, and you won't
> > > change anything about that by meddling with the
> > > generic target function
> > > call site.
     Your question is 
> > >So, in which iptables table do you intend to get 
at the output device?
     I want to know this in NAT table. 
regards,
cranium

--- Patrick Schaaf <bof@bof.de> wrote:
> Did you read the last paragraph of my mail? Note
> that it contained
> a question to you in the first sentence.
> 
> best regards
>   Patrick
> 
> On Fri, May 20, 2005 at 05:26:07AM -0700,
> cranium2003 wrote:
> > hello,
> >        Then how can i get information of on which
> > interface packet is going out of stack? I want to
> know
> > this in kenrel. I am doing some network kernel
> > programming where i want to get device name of
> > outgoing packet.
> >        I thought that when we use LOG rule it
> shows
> > that info. so decided to use that function. 
> > regards,
> > cranium
> > --- Patrick Schaaf <bof@bof.de> wrote:
> > > > I want to know which file in source code has
> > > pointer
> > > > to call ipt_log_target function?
> > > 
> > > Like any other target function, you'll find the
> > > call, as an indirect
> > > function call to ->target(), in
> > > net/ipv4/netfilter/ip_tables.c, function
> > > ipt_do_table.
> > > 
> > > > I want instance/copy of const struct
> net_device
> > > *out to my function in
> > > > kernel to know that eth0 or eth1 is
> transmitting
> > > packet.
> > > 
> > > The above information will not help you at all
> with
> > > this quest.
> > > The LOG target already shows input and output
> > > interface, IF THEY ARE
> > > KNOWN.
> > > 
> > > So, in which iptables table do you intend to get
> at
> > > the output device?
> > > Because, in some table it is simply not yet
> > > determined, and you won't
> > > change anything about that by meddling with the
> > > generic target function
> > > call site.
> > > 
> > > best regards
> > >   Patrick
> > > 
> > 
> > 
> > 		
> > __________________________________ 
> > Do you Yahoo!? 
> > Yahoo! Mail - Find what you need with new enhanced
> search. 
> > http://info.mail.yahoo.com/mail_250
> 


		
Yahoo! Mail
Stay connected, organized, and protected. Take the tour:
http://tour.mail.yahoo.com/mailtour.html
