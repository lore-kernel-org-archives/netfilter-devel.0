From: Ozgur AKAN <akan@aiqa.com>
Subject: parse_interface and argv[optind-1] argument?
Date: Fri, 02 Apr 2004 11:41:52 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <406D2750.5050705@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------010405070504020704040107"
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

This is a multi-part message in MIME format.
--------------010405070504020704040107
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
I could not find the value of first argument of the funciton below which 
is in iptables.c file.

static void parse_interface(const char *arg, char *vianame, unsigned 
char *mask)

"const char *arg" takes value of "argv[optind-1]". Is "argv[optind-1] " 
releated with modules/names?

thanks for help,
Ozgur AKAN





--------------010405070504020704040107
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-9">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
<font face="microsoft-verdana-iso10646-1">Hi,<br>
I could not find the value of first argument of the funciton below
which is in iptables.c file.<br>
<br>
static void parse_interface(const char *arg, char *vianame, unsigned
char *mask) <br>
<br>
</font><font face="microsoft-verdana-iso10646-1">"const char *arg"
takes value of "</font><font face="microsoft-verdana-iso10646-1">argv[optind-1]".
Is </font><font face="microsoft-verdana-iso10646-1">"</font><font
 face="microsoft-verdana-iso10646-1">argv[optind-1] </font><font
 face="microsoft-verdana-iso10646-1">" releated with modules/names?</font><br>
<font face="microsoft-verdana-iso10646-1"><br>
thanks for help,<br>
Ozgur AKAN<br>
<br>
<br>
<br>
<br>
</font>
</body>
</html>

--------------010405070504020704040107--
