From: Ozgur Akan <akan@aiqa.com>
Subject: argv[optind-1] == optarg
Date: Sat, 22 May 2004 21:44:41 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AF9F99.7070305@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------090101060805010602070006"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090101060805010602070006
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I think using optarg instead of argv[optind-1] will be better. In 
iptables.c; while parsing iptables options with getopt_long, 
argv[optind-1] is used in 8 places.

optarg (option argument) gives us the value of the option we are 
parsing. So when we do something with the argument of (for example) A 
option the easiest way to get the value of A`s argument is using optarg. 
optarg is designed to be used with getopt_long.

Using optind (option index) is more tricky because optind starts from 1 
and when we are parsing an option with an index of value n of argv array 
it shows n+2. That`s why we substract 1 from optind.

best wishes,
Ozgur Akan

--------------090101060805010602070006
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-9">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
<span style="font-family: microsoft-verdana-iso10646-1;">Hi,<br>
<br>
</span><span style="font-family: microsoft-verdana-iso10646-1;"> I
think using optarg instead of argv[optind-1] will be better. </span><span
 style="font-family: microsoft-verdana-iso10646-1;">In iptables.c;
while parsing iptables options with getopt_long, argv[optind-1] is used
in 8 places.<br>
<br>
optarg (option argument) gives us the value of the option we are
parsing. So when we do something with the argument of (for example) A
option the easiest way to get the value of A`s argument is using
optarg. optarg is designed to be used with getopt_long.<br>
<br>
Using optind (option index) is more tricky because optind starts from 1
and when we are parsing an option with an index of value n of argv
array it shows n+2. That`s why we substract 1 from optind.<br>
<br>
best wishes,</span><br>
Ozgur Akan<br>
</body>
</html>

--------------090101060805010602070006--
