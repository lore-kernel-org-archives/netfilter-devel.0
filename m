From: Bart <b-m@pandora.be>
Subject: Re: Plz Help
Date: Tue, 10 Dec 2002 00:30:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DF527AC.1030000@myland.org>
References: <4223A04BF7D1B941A25246ADD0462FF51BC18B@blr-m3-msg.wipro.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------000409090302010907090804"
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


--------------000409090302010907090804
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Have you already read about ulog and the ulog daemon.  It's possible to 
log to any file or even to sql.
And you can write your own extensions for it.

Greetz


Amit Kumar Gupta wrote:

>Hi List,
>
>I am having a problem abt IPtables Logging.
>The LOG target logs the messages to a particular file say /var/log/messages depending on the entries in syslog.conf. Now my problem is, i want to log messages in some other special file. Or i can say, a process is running which will receive all the LOg messages and will store it. I was thinking abt the sol for this. I went thro the code of iptables Logging in extensions folder. There are files like libipt_LOG.c where we are having print statements. So is it fine if those statements gets replaced with the api i will provide for logging in some special file. If it is, Then i think i have to write the patch for it.( And i think this patch is for iptables in usr mode only). 
>
>If it is not okay, Then i think i have to provide a new target which will do these things. But in that case, i don't know how i can do this.
>
>Plz give ur suggestions in both the cases.
>
>Thanks & Regards.
>Amit.
>  
>
>------------------------------------------------------------------------
>
>**************************Disclaimer**************************************************    
> 
> Information contained in this E-MAIL being proprietary to Wipro Limited is 'privileged' 
>and 'confidential' and intended for use only by the individual or entity to which it is 
>addressed. You are notified that any use, copying or dissemination of the information 
>contained in the E-MAIL in any manner whatsoever is strictly prohibited.
>
>****************************************************************************************
>  
>


--------------000409090302010907090804
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title></title>
</head>
<body>
Hi, <br>
 <br>
 Have you already read about ulog and the ulog daemon.  It's possible to
log to any file or even to sql.<br>
 And you can write your own extensions for it.<br>
 <br>
 Greetz<br>
<br>
<br>
Amit Kumar Gupta wrote:<br>
<blockquote type="cite"
 cite="mid4223A04BF7D1B941A25246ADD0462FF51BC18B@blr-m3-msg.wipro.com">
  <pre wrap="">Hi List,

I am having a problem abt IPtables Logging.
The LOG target logs the messages to a particular file say /var/log/messages depending on the entries in syslog.conf. Now my problem is, i want to log messages in some other special file. Or i can say, a process is running which will receive all the LOg messages and will store it. I was thinking abt the sol for this. I went thro the code of iptables Logging in extensions folder. There are files like libipt_LOG.c where we are having print statements. So is it fine if those statements gets replaced with the api i will provide for logging in some special file. If it is, Then i think i have to write the patch for it.( And i think this patch is for iptables in usr mode only). 

If it is not okay, Then i think i have to provide a new target which will do these things. But in that case, i don't know how i can do this.

Plz give ur suggestions in both the cases.

Thanks &amp; Regards.
Amit.
  </pre>
  <pre wrap="">
<hr width="90%" size="4">
**************************Disclaimer**************************************************    
 
 Information contained in this E-MAIL being proprietary to Wipro Limited is 'privileged' 
and 'confidential' and intended for use only by the individual or entity to which it is 
addressed. You are notified that any use, copying or dissemination of the information 
contained in the E-MAIL in any manner whatsoever is strictly prohibited.

****************************************************************************************
  </pre>
</blockquote>
<br>
</body>
</html>

--------------000409090302010907090804--
