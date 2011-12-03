From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: doc: Secure use of iptables and connection tracking helpers
Date: Sat, 03 Dec 2011 13:41:41 +0000
Message-ID: <4EDA2715.7030006@googlemail.com>
References: <1322501576.20587.22.camel@tiger.regit.org>		 <1322906769.8042.4.camel@hakkenden.homenet>	 <1322911416.603.2.camel@ice-age.regit.org>	 <4EDA1BE9.4060703@googlemail.com> <1322917503.2568.2.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Nikolay S." <nowhere@hakkenden.ath.cx>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kaber@trash.net
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45131 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab1LCNlw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Dec 2011 08:41:52 -0500
In-Reply-To: <1322917503.2568.2.camel@ice-age.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>>> Really good catch, I've published an update.
>>>   
>>>       
>> I don't want to be seen as "picky", but there is a spelling mistake at 
>>     
>
> no problem with that.
>   
OK then (you asked for it :-P ):

p.1 "but it is stored in a separate table and as generally a limited 
duration" ("as" should be "has")
p.2 "conjonction" should be "conjunction"
p.2 "If your clients are authorized to access to FTP outside of your 
network you can add" should be "If your clients are authorized to access 
FTP outside of your network you can add"
p.4 "has described below" ("has" should be "as")
p.4 "Once an helper is loaded" should be "Once helper is loaded"
p.4 "it will treat the packet for a given port and all IP" should be "it 
will treat the packet for a given port and all IP addresses"
p.4 "desactivate" should be "deactivate"
p.4 "It is possible to obtain this behaviour for most connection 
tracking helper module by setting to 0 the port number for the module." 
should be "It is possible to obtain this behaviour for most connection 
tracking helper modules by setting the port number for the module to 0."
p.4 "The following modules will be desactivated on all flows by default 
by doing this: ftp irc sane sip tftp" - 1) "desactivated" should be 
"deactivated"; 2) The whole sentence does not make sense: - what does 
"desactivated on all flows by default" mean? Having "deactivated on all 
flows" (with the right spelling and without the "by default" bit) makes 
more sense if you mean that by setting the "port 0" all of the listed 
modules will be deactivated.
p.4 "Some modules will no work dut to the abscence of ports parameter" 
("no" to "not" and "abscence" to "absence")
p.5 "Antispoofing" should be "Anti-spoofing"
p.5 "Helper lays on the parsing of data that come from client or from 
server" should be either "Helpers rely on parsing of data that comes 
from a client or a server" or "A helper relies on parsing of data that 
comes from a client or a server"
p.5 "It is thus important" should be "Therefore, it is important"
p.5 "Linux provides a routing based implementation" should be "Linux 
provides a routing-based implementation"
p.5 "To activate it you need to ensure that the 
/proc/sys/net/ipv4/conf/*/rp_filter" should be "To activate it you need 
to ensure that /proc/sys/net/ipv4/conf/*/rp_filter"
p.5 "The complete documentation about rp_filter is available in the file 
ip-sysctl.txt" should be "Complete documentation about rp_filter is 
available in ip-sysctl.txt"
p.6 "There is at the time of the writing no routing-based implementation 
of rp_filter in the Linux kernel." should be "At the time of writing, 
there is no routing-based implementation of rp_filter in the Linux kernel."
p.6 "anit-spoofing" should be "anti-spoofing"
p.6 "shortcutting" should be "short-cutting" or "bypassing"
p.6 "This help to reduce the load" should be "This helps reducing the load"
p.6 "The antispoofing must be done a a per-interface way" should be 
"Anti-spoofing must be done on a per-interface basis"
p.6 "There is an exception which is the interface with the default 
route" should be "There is exception, which is the interface with the 
default route"
p.6 "and have eth0 the interface with the default route" should be "and 
have the eth0 interface with a default route"
p.6 "antispoofing with the following rules" should be "anti-spoofing 
with the following rules:"


>> the 3rd line on the very first page of this document - "negociate" 
>> should be "negotiate". It is worth running a spell-checker on this 
>> entire document though - just in case I've missed something. ;-)
>>     
>
> It seems your document is outdated. If not please tell me where you've
> got it. And all my apologies for the spelling mistake in first version.
>   
I've just downloaded it from the link in your previous post/reply: 
http://home.regit.org/wp-content/uploads/2011/11/helper-recommandation.pdf

