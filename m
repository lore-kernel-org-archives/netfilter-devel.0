From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Packet Fragementation
Date: Tue, 30 Mar 2004 12:06:03 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040330200603.52210.qmail@web13903.mail.yahoo.com>
References: <40695616.9030809@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <40695616.9030809@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Is the defragmented packet the thing passed up to the
userspace application?
If so, where in the whole netfilter process is the
packet re-fragmented? 
Oh, also, if a defragmented packet is passed up, then
I could see the buffer needs to be fairly large
(potentially).  Is there a way to tell how big an
incoming message awaiting delivery via ipq_read() is? 
Is there a way to keep conntrack from passing up a
de-fragmented packet (so still have conntrack make
it's session info, but not pass up defragmented data)?

Thanks!
-Scott

--- Pablo Neira <pablo@eurodev.net> wrote:
> Hi Sara,
> 
> Sara Kostandy wrote:
> 
> > We're developing an XML firewall application as
> part of our senior 
> > graduation project. We are using Linux 2.4 and
> queuing packets to be 
> > handled in user-space. However the packets
> arriving are fragmented, 
> > and so are more difficult to deal with. Is there a
> way to defragment 
> > them before they are queued to user-space??
> >
> In 2.4, the easiest way is loading the ip_conntrack
> module which will 
> gather all the fragments and put them in a continuos
> memory area, this 
> means that you won't need to deal with fragments
> anymore.
> 
> regards,
> Pablo
> 
> 

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
