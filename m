From: Jesse Peng <jesse@deansoft.com.tw>
Subject: Re: ip_conntrack_get
Date: Tue, 09 Dec 2003 17:48:37 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD59A75.7020709@deansoft.com.tw>
References: <Pine.LNX.4.44.0312090916320.23521-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------030208070304080406010408"
Cc: pablo neira <pablo@eurodev.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------030208070304080406010408
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit

Henrik Nordstrom wrote:

>On Tue, 9 Dec 2003, Jesse Peng wrote:
>
>  
>
>>while a new ip_conntrack cache initiates, every member 
>>infos[i](nf_ct_info structure) then be charged with the same address 
>>value pointing to the ip_conntrack cache's begining address(it's the 
>>address of its first member nf_conntrack structure naming ct_general also).
>>    
>>
>
>Right.. now I get why this construct is looking like it does. It is a 
>tradeoff "wasting" some space per conntrack to limit the mount of fields 
>needed in the skb.
>
>By using this construct both the ctinfo and conntrack can be derived from
>a single pointer in the skb.
>
>For systems using conntrack a lot it would be more efficient to extend the
>skb with one more field for ctinfo, but as it is good if the skb is the
>same regardless if conntrack is enabled or not and this construct is a
>good tradeoff.
>
>It is however possible to reduce the size of this construct considerably 
>to just one byte per ctinfo.
>
>Thanks
>Henrik
>
>  
>
As I never deeply think how this construct can be redesigned, after read 
your insight.. now I begin to figure out why the skbuff.h prevent 
including ip_conntrack.h, and why nf_conntrack defined in skbuff.h

Thanks
Jesse


--------------030208070304080406010408
Content-Type: text/html; charset=US-ASCII
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title></title>
</head>
<body>
Henrik Nordstrom wrote:<br>
<blockquote type="cite"
 cite="midPine.LNX.4.44.0312090916320.23521-100000@filer.marasystems.com">
  <pre wrap="">On Tue, 9 Dec 2003, Jesse Peng wrote:

  </pre>
  <blockquote type="cite">
    <pre wrap="">while a new ip_conntrack cache initiates, every member 
infos[i](nf_ct_info structure) then be charged with the same address 
value pointing to the ip_conntrack cache's begining address(it's the 
address of its first member nf_conntrack structure naming ct_general also).
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Right.. now I get why this construct is looking like it does. It is a 
tradeoff "wasting" some space per conntrack to limit the mount of fields 
needed in the skb.

By using this construct both the ctinfo and conntrack can be derived from
a single pointer in the skb.

For systems using conntrack a lot it would be more efficient to extend the
skb with one more field for ctinfo, but as it is good if the skb is the
same regardless if conntrack is enabled or not and this construct is a
good tradeoff.

It is however possible to reduce the size of this construct considerably 
to just one byte per ctinfo.

Thanks
Henrik

  </pre>
</blockquote>
As I never deeply think how this construct can be redesigned, after read
your insight.. now I begin to figure out why the skbuff.h prevent including
ip_conntrack.h, and why nf_conntrack defined in skbuff.h <br>
<br>
Thanks<br>
Jesse<br>
<br>
</body>
</html>

--------------030208070304080406010408--
