From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: indev_name in bridge+iptables?
Date: Sat, 12 Jul 2003 08:27:59 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030712152759.5547.qmail@web13905.mail.yahoo.com>
References: <004801c345d8$8f9d9eb0$8101a8c0@dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yong <sdssly@sina.com>, netfilter-devel@lists.netfilter.org
In-Reply-To: <004801c345d8$8f9d9eb0$8101a8c0@dev>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi, I had the exact same thing.  The physical name is
not passed up in the message, sucks huh?

What I resorted to was to alter the kernel code for
the QUEUE messages.  The low level structure has the
physical device names in it, but are not passed up.  I
altered it so if there was a physical device name for
in & out, it copied those values over the existing
indev and outdev names (since 'br0' is pretty
useless).  There is only 1 file to change, but can't
remember it off the top of my head.  The 'real' method
would be to alter the _msg structure to include the
physdev names in it, but I was lazy :P

-Scott


--- Yong <sdssly@sina.com> wrote:
> Hello All,
> 
> I have a question about the ipq_packet_msg_t struct
> in bridge+iptables environment.
> 
> In the forward chain,  the indev and outdev name are
> the same: br0(my bridge port).
> 
> In the mangle prerouting chain, the indev is br0,
> the outdev is null. 
> 
> How to get the real in/out device(it is eth0 and
> eth1)?
> 
> Thanks in advance!


__________________________________
Do you Yahoo!?
SBC Yahoo! DSL - Now only $29.95 per month!
http://sbc.yahoo.com
