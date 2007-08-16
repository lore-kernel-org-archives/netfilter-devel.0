From: Abhinav Srivastava <abhinavs_iitkgp@yahoo.co.in>
Subject: Re: Locking issue
Date: Thu, 16 Aug 2007 19:27:58 +0100 (BST)
Message-ID: <652318.55542.qm@web7912.mail.in.yahoo.com>
References: <1187287905.3005.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1187287905.3005.2.camel@localhost.localdomain>
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


--- Bart De Schuymer <bdschuym@pandora.be> wrote:

> Op do, 16-08-2007 te 18:54 +0100, schreef Abhinav
> Srivastava:
> > 
> > Hi there,
> > 
> > This email is regarding ebtables code i.e. bridge
> > level filtering framework of netfilter. I have
> sent
> > this email to ebtables mailing list also but have
> not
> > heard from anyone. Hence, am sending this here
> too. I
> > hope i will receive some favorable response.
> > 
> > I am new to ebtables code and looking for some
> help
> > related to locking and atomicity. I am interested
> in
> > looking into the packets intercepted by ebtables,
> > extract some information, pass this information to
> > userspace, wait for userspace response and then
> pass
> > the result back to ebtable code.
> 
> What you seek is a QUEUE target as it exists for
> iptables. Unfortunately
> this doesn't yet exist for ebtables. Maybe you can
> get away with it by
> using the ebtables ulog watcher.
> 
> cheers,
> Bart


Hi Bart,

Thanks a lot for your quick reply. I really
appreciate.

As far as I know about ulog, it just sends the packet
to userspace logging deamon and do not wait for its
reply. Does ulog provide waiting/blocking feature also
that i can use in my code?

In my case, my requirement is to pass some packet
header information to userspace tool and wait for its
reply. During this process kernel code should block
and wait for user response. Once it receives user
response, it can go ahead. Like ulog, I am also using
netlink socket for communication between kernel and
userspace.

Is there anyway I can wait inside that code and let me
userspace tool run so that i could receive response
from it?

Once again thanks for your reply.

Thanks,
Abhinav 



      5, 50, 500, 5000 - Store N number of mails in your inbox. Go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html
