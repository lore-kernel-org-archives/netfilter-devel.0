From: Unit Zero <onyx@zero.fdns.net>
Subject: Re: taking related connections to the limit
Date: Thu, 4 Mar 2004 18:27:40 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.56L0.0403041817120.12843@zero.fdns.net>
References: <20040304120402.GH14383@magicbluesmoke.net> <200403042229.14348.lists@edeca.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "John P. Looney" <valen@tuatha.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: david@edeca.net
In-Reply-To: <200403042229.14348.lists@edeca.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



On Thu, 4 Mar 2004, David Cannings wrote:

> On Thursday 04 March 2004 12:04, John P. Looney wrote:
> >  Hi, I was wondering if netfilter can do the following:
> >
> >  If a packet has dest ip X, dport 110, do a DNAT --to IP Y, record the
> > SRC IP If a subsequent packet comes into dest IP X, from that SRC IP,
> > --dport 25 from the same IP, DNAT --to IP Y also.
> >
> >  This is to do some work with POP-before-smtp, if you wondered why such
> > a demented thing would be needed.
> 
> I am not sure whether it can be done or not but remember that they would 
> only have to connect in order to be allowed subsequent access to your 
> SMTP server.  netfilter obviously cannot handle authentication for POP3 
> so will never know whether the user was successful in their connection 
> attempt.  Normally, POP before SMTP is based on their username/password 
> being entered successfully to POP, which allows later access to SMTP.

You can actually handle authenticated POP-before-SMTP by having 
a script run from metalog (or whatever syslogd you like) the checks for
the log line when POP authentication is verified and greps the IP of the 
client, then adding it to ipt_recent's list by writing to it's 
/proc/net/ipt_recent file. and the nice thing about ipt_recent is that it 
will let you time-out the SMTP window after a certain period of 
inactivity.

> Personally I've always found authenticated SMTP to be a better 
> alternative.  It means I can give only selected POP users access to SMTP 
> and also I can give non POP users access, if need be.

This is very true... and I agree. A small issue might be configuration of 
authenticated SMTP on other platforms... like windows... does it even 
support it? I wouldn't be at all surprised if it didn't. and if it does, I 
wouldn't be surprised if it dosen't actually work anyway :)

> Just something so think about, perhaps.
> 
> David
> 

- Vic M. Condino
