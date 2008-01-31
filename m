From: Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>
Subject: Re: cups slow on linux-2.6.24
Date: Thu, 31 Jan 2008 04:25:49 +0100
Message-ID: <47A13FBD.8050803@trash.net>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>	
	<Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>	
	<b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>	
	<47A07FEA.3000702@trash.net>	
	<b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>	
	<b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>	
	<47A13573.7090804@trash.net>
	<b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>
Reply-To: "Mirror of cups.bugs Newsgroup" <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Krzysztof Piotr Oledzki <ole-gcSpNFQc7Gg@public.gmane.org>,
	Netfilter Development Mailinglist <netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cups-bugs <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
To: Jeff Chua <jeff.chua.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <b6a2187b0801301921s4a7842cg6cfec09a393cd63-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
Errors-To: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Jeff Chua wrote:
> On Jan 31, 2008 10:41 AM, Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org> wrote:
>
>   
>> Thanks. In the dump we can see that connections reusing ports
>> always have their first SYN dropped and retransmissted three
>> seconds later. I'm not sure whats causing this yet, do you have
>> any firewall rules that affect loopback traffic?
>>     
>
> No firewall.
>
> And the "lp" is just to print to a file@localhost.
>
> # lpadmin -p lp -i /etc/cups/interfaces/lp -v lpd://localhost/file -o
> printer-error-policy=retry-job
> # lpadmin -p file -i /etc/cups/interfaces/file -v file:/dev/null -o
> printer-error-policy=retry-job
>
> Filter for lp is ..
>   cat $6
>
> Filter for file is ...
>   cat $6 >/tmp/$$
>   

Actually its probably the SYN/ACK that is dropped. Please try whether

modprobe ipt_LOG
echo 255 >/proc/sys/net/netfilter/nf_conntrack_log_invalid

and then running the test again logs something to the ring buffer.
You don't need to run the entire test, just until you get a log
message from conntrack.
