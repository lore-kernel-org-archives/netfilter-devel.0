From: Eicke Friedrich <tady@gmx.net>
Subject: Re: Feasability of Protocol Filtering
Date: Thu, 24 Apr 2003 21:38:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA83D34.8040909@gmx.net>
References: <3EA7056F.2050601@gmx.net> <1051137456.28404.34.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1051137456.28404.34.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:
> I do something similar here, no problem to do two stringmatches on a
> 100Mbit/s link.
What about throughput, packets per second and latency? Do you have any experiences? I'm 
going to face a 100MBit/sec link in a couple of months so any hints are appreciated. By 
the way it's a Linux Bridge with netfilter support that has nothing else to do than 
marking p2p-packets and put them in a HTB class to reduce the "wasted" bandwidth.

> If using the Boyer-Moore algorithm instead you get it down to ~3k cycles
> / kB when searching for a 5 byte string (cpu usage decreases with string
> length)
Maybe it's not so important for my project because i know the exact position in the 
payload where the string has to be so i don't search the whole packet but just the 
specific position in the payload.
For this purpose i use memcmp(kazaa) or memchr(edonkey) - maybe there is a way to improve 
this?

int
search_kazaa (char *needle, char *haystack, int needle_len)
{
     char *t = haystack;

     t += 20;		//skippin tcp-header

     if (memcmp(t, needle, needle_len) == 0)
         return 1;
     else
         return 0;

}

This is the one for kazaa where needle is the string "GET /.hash=" and haystack is the 
ip-packet. Next one is similar but i'm just searching for 0xe3 and 0x47 (edonkey get 
segment command).

int
search_edk (char *haystack)
{
     char *t = haystack;

     t += 20;		//skippin tcp-header
     if (memchr(t, 0xe3, 1) == 0)
         return 0;
     else
         t += 5;		//jump to command position
         if (memchr(t, 0x47, 1) != 0) return 1;
         else return 0;

}


Best regards,
Eicke.
