From: "hMax Roth" <mroth2002@hotmail.com>
Subject: 2 questions about skb->data
Date: Wed, 25 Sep 2002 18:49:02 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F106uCumiiq6KcvflGx00006117@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Hello,
   Two quick questions:
      1) Judging by the code it looks like all the skb's are
      linearized prior to entering the hooks. Is this right?
      2) Am I free to manipulate the data in the skb? Judging
      from various web resources, it looks as if the data can
      either be private or shared.  how do I tell if I can
      overwrite data in the skb->data pointer safely? Do I need
      to make my own copy of the skb first?
      regards, max.

p.s. sorry about the hotmail tag, I've been warned.  I will try to
find a new email provider soon.


_________________________________________________________________
MSN Photos is the easiest way to share and print your photos: 
http://photos.msn.com/support/worldwide.aspx
