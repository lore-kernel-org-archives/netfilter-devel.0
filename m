From: Jesse Peng <jesse@deansoft.com.tw>
Subject: Re: Counter problem in a new nat target.
Date: Wed, 10 Dec 2003 16:35:52 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD6DAE8.5040205@deansoft.com.tw>
References: <Pine.LNX.4.44.0312091107570.24092-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------000309080508020301070601"
Cc: Emmanuel Guiton <emmanuel@netlab.hut.fi>,
   netfilter-devel@lists.netfilter.org
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


--------------000309080508020301070601
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Henrik Nordstrom wrote:

>On Tue, 9 Dec 2003, Emmanuel Guiton wrote:
>
>  
>
>>My problem is that I do not see which data can be accessed by any of the 
>>function involved. To be precise, I need to increment a counter each 
>>time I get one new conntrack. Then I decrement it each time a conntrack 
>>is destroyed or set as assured (tcp connection).
>>    
>>
>
>Then the problem is a lot more complex.
>
>Increasing is not a big problem, but the decreasing are as it is hard to 
>find which counter to decrease from the conntrack and there is no good 
>place to store such information for later without extending the 
>ip_conntrack structure unless you implement this as a conntrack 
>application protocol helper (can be done if no other conntrack helper is 
>needed in the relevant traffic).
>
>Do you really need to decrease the counters?
>  
>
I think there will remain two alternative ways to deal with the 
decrementing counter problem:

1.You maintain a hash struture which list any of your concerning 
conntrack, and while a conntrack facing destroyed then looking  up this 
hash list if it is on the list.
2.I don't think you need any real helper no matter how simple it can 
be.But just to extend your target module while matching ip_ct_new put 
some flags in the help 
information(conntrack->help.Your_patched_private_help_info)indecate that 
this is the conntrack you care. And then while a conntrack facing 
destroyed then looking  up its help info if it is flaged. But if the 
traffic you wanna filter overlaps with other helpers(eg. 
ip_conntrack_ftp),then a somewhat dirty way regarding where you put your 
flags(because help info is only for one helper)is to put them in 
conntrack->nat.help.Your_patched_private_help_info(for this is 
relatively a virgin place seldom touched by famous helpers except as I 
know the pptp helper)

But no matter which above you choose, You can't avoid patching your 
private destroying code like how ip_conntrack_destroyed(destroying code 
for NATed conntrack) been called.Because so far we never see any 
extending conntrack destroying machenism concerning helper's private 
functionality(like helper->destroy).
Hope this can help ;)!

Regards
Jesse

--------------000309080508020301070601
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title></title>
</head>
<body>
Henrik Nordstrom wrote:<br>
<blockquote type="cite"
 cite="midPine.LNX.4.44.0312091107570.24092-100000@filer.marasystems.com">
  <pre wrap="">On Tue, 9 Dec 2003, Emmanuel Guiton wrote:

  </pre>
  <blockquote type="cite">
    <pre wrap="">My problem is that I do not see which data can be accessed by any of the 
function involved. To be precise, I need to increment a counter each 
time I get one new conntrack. Then I decrement it each time a conntrack 
is destroyed or set as assured (tcp connection).
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Then the problem is a lot more complex.

Increasing is not a big problem, but the decreasing are as it is hard to 
find which counter to decrease from the conntrack and there is no good 
place to store such information for later without extending the 
ip_conntrack structure unless you implement this as a conntrack 
application protocol helper (can be done if no other conntrack helper is 
needed in the relevant traffic).

Do you really need to decrease the counters?
  </pre>
</blockquote>
I think there will remain two alternative ways to deal with the decrementing
counter problem:<br>
<br>
1.You maintain a hash struture which list any of your concerning conntrack,
and while a conntrack facing destroyed then looking &nbsp;up this hash list if
it is on the list.<br>
2.I don't think you need any real helper no matter how simple it can be.But
just to extend your target module while matching ip_ct_new put some flags
in the help information(conntrack-&gt;help.Your_patched_private_help_info)indecate
that this is the conntrack you care. And then while a conntrack facing destroyed
then looking &nbsp;up its help info if it is flaged. But if the traffic you wanna
filter overlaps with other helpers(eg. ip_conntrack_ftp),then a somewhat
dirty way regarding where you put your flags(because help info is only for
one helper)is to put them in conntrack-&gt;nat.help.Your_patched_private_help_info(for
this is relatively a virgin place seldom touched by famous helpers except
as I know the pptp helper)<br>
<br>
But no matter which above you choose, You can't avoid patching your private
destroying code like how ip_conntrack_destroyed(destroying code for NATed
conntrack) been called.Because so far we never see any extending conntrack
destroying machenism concerning helper's private functionality(like helper-&gt;destroy).<br>
Hope this can help ;)!<br>
<br>
Regards<br>
Jesse<br>
</body>
</html>

--------------000309080508020301070601--
