From: "=?ISO-8859-1?Q?Jos=E9=20Queiroz?=" <JQueiroz@prrj.mpf.gov.br>
Subject: About LOG facilities
Date: Mon, 01 Sep 2003 11:07:12 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <sf532e79.001@fs-mail.prrj.mpf.gov.br>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="=_E5BB84B9.B9D846BD"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--=_E5BB84B9.B9D846BD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi,
 
I m working with iptables (1.2.4) and I'm interested on setting a log
facility along with loglevel, said, auth.alert instead of simply
'alert'.
 
I know that iptables is coded so "log levels" are tied to levels 0-7,
and that there is no possibility to set the facility (hardcoded to
"Kernel").
 
So I came to suggest you to add this facility (and those "facilities")
to iptables front-end.
 
Also, looking at the soruce code, I saw that you had coded the
log-level strings within your sources. But the header file
<sys/syslog.h> have these log-level strings also, so these can be used
as:
 
typedef struct _code {
        char    *c_name;
        int     c_val;
} CODE;

CODE prioritynames[], facilitynames[];
 
both these tables have a "{ NULL, -1}" as its last entry. 
 
Speaking of limiting possible choices on facility/priority numerical
codes, there's also some constants, as LOG_PRIMASK and  LOG_FACMASK,
which can be combined to form a "LOG_LEVELMASK" and/or a
"LOG_MAXLEVEL".
 
Relevant system versions: Kernel 2.4.19, Sysklogd 1.4.1, Distribution:
Conectiva Linux 8+
 
Thanks in advance.
 
----------------------------------------------------------------
José D. Queiroz - Analista de Informática
MPF/PR/RJ/CDIJ/DDI/Gerência de Rede
jqueiroz@prrj.mpf.gov.br
jdqueiroz@ibest.com.br 
----------------------------------------------------------------


--=_E5BB84B9.B9D846BD
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=iso-8859-1">
<META content="MSHTML 6.00.2800.1170" name=GENERATOR></HEAD>
<BODY style="MARGIN-TOP: 2px; FONT: 10pt MS Sans Serif; MARGIN-LEFT: 2px">
<DIV>Hi,</DIV>
<DIV>&nbsp;</DIV>
<DIV>I´m working with iptables (1.2.4) and I'm interested on setting a log 
facility along with loglevel, said, auth.alert instead of simply 'alert'.</DIV>
<DIV>&nbsp;</DIV>
<DIV>I know that iptables is coded so "log levels" are tied to levels 0-7, and 
that there is no possibility to set the facility (hardcoded to "Kernel").</DIV>
<DIV>&nbsp;</DIV>
<DIV>So I came to suggest you to add this facility (and those "facilities") to 
iptables front-end.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Also, looking at the soruce code, I saw that you had coded the log-level 
strings within your sources. But the header file &lt;sys/syslog.h&gt; have these 
log-level strings also, so these can be used as:</DIV>
<DIV>&nbsp;</DIV>
<DIV>typedef struct _code {<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
char&nbsp;&nbsp;&nbsp; *c_name;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
int&nbsp;&nbsp;&nbsp;&nbsp; c_val;<BR>} CODE;<BR></DIV>
<DIV>CODE prioritynames[], facilitynames[];</DIV>
<DIV>&nbsp;</DIV>
<DIV>both these tables have a "{ NULL, -1}" as its last entry. </DIV>
<DIV>&nbsp;</DIV>
<DIV>Speaking of limiting possible choices on facility/priority numerical codes, 
there's also some constants, as LOG_PRIMASK and&nbsp; LOG_FACMASK, which can be 
combined to form a "LOG_LEVELMASK" and/or a "LOG_MAXLEVEL".</DIV>
<DIV>&nbsp;</DIV>
<DIV>Relevant system versions: Kernel 2.4.19, Sysklogd 1.4.1, Distribution: 
Conectiva Linux 8+</DIV>
<DIV>&nbsp;</DIV>
<DIV>Thanks in advance.</DIV>
<DIV>&nbsp;</DIV>
<DIV>----------------------------------------------------------------<BR>José D. 
Queiroz - Analista de Informática<BR>MPF/PR/RJ/CDIJ/DDI/Gerência de Rede<BR><A 
href="mailto:jqueiroz@prrj.mpf.gov.br">jqueiroz@prrj.mpf.gov.br</A><BR><A 
href="mailto:jdqueiroz@ibest.com.br">jdqueiroz@ibest.com.br</A><BR>----------------------------------------------------------------<BR></DIV></BODY></HTML>

--=_E5BB84B9.B9D846BD--
