From: Jesse Peng <jesse@deansoft.com.tw>
Subject: Re: ip_conntrack_get
Date: Tue, 09 Dec 2003 11:58:34 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD5486A.6060007@deansoft.com.tw>
References: <Pine.LNX.4.44.0311120051400.14633-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------070608090201050009000108"
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


--------------070608090201050009000108
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit

Henrik Nordstrom wrote:

>>I also don't understand the way ctinfo is calculate. This stuff...
>>
>>403 <http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L403>         *//* ctinfo is the index of the nfct inside the conntrack *//*
>>404 <http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L404>         *ctinfo = nfct - ct->infos;
>>    
>>
>
>Neither do I.. but then I have never needed to care as ip_conntrack_get()  
>and the conntrack core does a good job of hiding the magics in that area.. 
>it is probably quite simple reasons behind this odd looking construct.
>
>Regards
>Henrik
>
>
>  
>
Execuse me for the late response,for I thought my colleague would taken 
the responsibility. As I think, just same as me, Pablo must be very 
interested in learning netfilter ;)!

while a new ip_conntrack cache initiates, every member 
infos[i](nf_ct_info structure) then be charged with the same address 
value pointing to the ip_conntrack cache's begining address(it's the 
address of its first member nf_conntrack structure naming ct_general also).

code reference:ip_conntrack_core.c ->init_conntrack ->
for (i=0; i < IP_CT_NUMBER; i++)
conntrack->infos[i].master = &conntrack->ct_general;

either the first packet which initiates the ip_conntrack initiation or 
any subsequent packets belonging to this connection, after 
resolve_normal_ct, will get its member pointer structure nf_ct_info 
naming nfct burned the address pointing to the concerning infos[i](the i 
is right the ctinfo we figure out during resolve_normal_ct, as you know, 
which indecates the relation this packet with its belonging connection).

code reference:ip_conntrack_core.c ->resolve_normal_ct ->
skb->nfct = &h->ctrack->infos[*ctinfo];

ok! now with the address of info[i] the pskb get, we can figure out two 
things.First, following the pointer to its address, with the value it 
keeps, we get the address of the ip_conntrack.Second,following the 
ip_conntrack we can get the address of infos[0],then with 
infos[i]-infos[0](nfct-ct->infos),we get the i, which is right the 
*ctinfo we wanna know!

code reference:ip_conntrack_core.c ->__ip_conntrack_get ->
struct ip_conntrack *ct
= (struct ip_conntrack *)nfct->master; 
-------------------------------------->first

/* ctinfo is the index of the nfct inside the conntrack */
*ctinfo = nfct - ct->infos; -------------------------------------->second

I don't know if this answer your question? if not, it's time to improve 
my English expression ;)!



--------------070608090201050009000108
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
 cite="midPine.LNX.4.44.0311120051400.14633-100000@filer.marasystems.com">
  <pre wrap=""></pre>
  <blockquote type="cite">
    <pre wrap="">I also don't understand the way ctinfo is calculate. This stuff...

403 <a class="moz-txt-link-rfc2396E" href="http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L403">&lt;http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L403&gt;</a>         *//* ctinfo is the index of the nfct inside the conntrack *//*
404 <a class="moz-txt-link-rfc2396E" href="http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L404">&lt;http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L404&gt;</a>         *ctinfo = nfct - ct-&gt;infos;
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Neither do I.. but then I have never needed to care as ip_conntrack_get()  
and the conntrack core does a good job of hiding the magics in that area.. 
it is probably quite simple reasons behind this odd looking construct.

Regards
Henrik


  </pre>
</blockquote>
Execuse me for the late response,for I thought my colleague would taken the
responsibility. As I think, just same as me, Pablo must be very interested
in learning netfilter ;)!<br>
<br>
while a new ip_conntrack cache initiates, every member infos[i](nf_ct_info
structure) then be charged with the same address value pointing to the ip_conntrack
cache's begining address(it's the address of its first member nf_conntrack
structure naming ct_general also).<br>
<br>
code reference:ip_conntrack_core.c -&gt;init_conntrack -&gt;<br>
&nbsp;&nbsp;&nbsp; for (i=0; i &lt; IP_CT_NUMBER; i++)<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; conntrack-&gt;infos[i].master = &amp;conntrack-&gt;ct_general;<br>
<br>
either the first packet which initiates the ip_conntrack initiation or any
subsequent packets belonging to this connection, after resolve_normal_ct,
will get its member pointer structure nf_ct_info naming nfct burned the address
pointing to the concerning infos[i](the i is right the ctinfo we figure out
during resolve_normal_ct, as you know, which indecates the relation this
packet with its belonging connection).<br>
<br>
code reference:ip_conntrack_core.c -&gt;resolve_normal_ct -&gt;<br>
skb-&gt;nfct = &amp;h-&gt;ctrack-&gt;infos[*ctinfo];<br>
<br>
ok! now with the address of info[i] the pskb get, we can figure out two things.First,
following the pointer to its address, with the value it keeps, we get&nbsp; the
address of the ip_conntrack.Second,following the ip_conntrack we can get
the address of infos[0],then with infos[i]-infos[0](nfct-ct-&gt;infos),we
get the i, which is right the *ctinfo we wanna know! <br>
<br>
code reference:ip_conntrack_core.c -&gt;__ip_conntrack_get -&gt;<br>
struct ip_conntrack *ct<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; = (struct ip_conntrack *)nfct-&gt;master; --------------------------------------&gt;first<br>
<br>
&nbsp;&nbsp;&nbsp; /* ctinfo is the index of the nfct inside the conntrack */<br>
&nbsp;&nbsp;&nbsp; *ctinfo = nfct - ct-&gt;infos; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;--------------------------------------&gt;second<br>
<br>
I don't know if this answer your question? if not, it's time to improve my
English expression ;)!<br>
<br>
<br>
</body>
</html>

--------------070608090201050009000108--
