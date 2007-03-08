From: "Kanhu Rauta" <choiskanhu@gmail.com>
Subject: IP Defragmentation
Date: Thu, 8 Mar 2007 11:45:58 +0530
Message-ID: <4c348ac20703072215x63a7a315kd018e433c7a197d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org,
	kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Return-path: <linux-net-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi list,

I am using kernel 2.6.20.1. I have written a module,which will
register a function at local_in hook, i have found a strange behavior
with the packets getting in my callback function i.e

[let say i am sending 1500 bytes to this machine from the network]
ping -s 1500 <ip>

1>in case of fragmention i am getting only one packet at the
hook,While analyzing the ip header it says this is the assembled
packet(skb->len=1528,offset=0,MF=0).

While dumping the data(for 0 to 1528 print skb->data[i]) it shows that
only 1472 bytes are valid data and rest 28 bytes are something
garbage.
I verified this with ethereal.

2>I have dumped these packets in ip_local_deliver function after
ip_defrag and before NF_HOOK,But the result is same.

Can Anybody let me know why i am not getting the complete data ?

Regards,
kanhu
