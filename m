From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Userspace msg, hw_addr unused?
Date: Thu, 15 Jan 2004 06:00:00 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040115140000.52096.qmail@web13902.mail.yahoo.com>
References: <20040115133217.86413.qmail@web13909.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040115133217.86413.qmail@web13909.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In poking around, I think I see what would be needed. 
Any confirmation would be great.
entry->skb has a mac.ethernet structure.  This looks
to be a ethhdr, so it has a h_source and h_dest.
2 options seem to be to add a ethdr to the
ipq_packet_msg and memcpy the entry->skb->mac.ethernet
or to add 2 fields (maybe removing the hw_addr if
unused) and memcpy the h_source and h_dest.

I think, if I alter those fields, though, that there
is alot of recompile needed.  Is there a better way to
get to the ethernet fields?


--- Scott MacKay <scottmackay@yahoo.com> wrote:
> I was looking thru the userspace code for material
> passed up in the ipq_packet_msg structure, looking
> for
> any data from the ethernet header.  I noticed that
> the
> hw_addr array never seems to be filled out, even
> though hw_addrlen does.  Any reason for that?
> 
> Also, if I wanted to patch the kernel's ip_queue.c
> to
> pass up the source and destination ether address,
> any
> ideas on where I get the packet's data from? 
> Thanks!!
> 
> __________________________________
> Do you Yahoo!?
> Yahoo! Hotjobs: Enter the "Signing Bonus"
> Sweepstakes
> http://hotjobs.sweepstakes.yahoo.com/signingbonus
> 


__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
