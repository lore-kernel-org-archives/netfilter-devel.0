From: "Amit Kumar Gupta" <amitkumar.gupta@wipro.com>
Subject: Plz Help
Date: Tue, 3 Dec 2002 10:30:25 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4223A04BF7D1B941A25246ADD0462FF51BC18B@blr-m3-msg.wipro.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-e9fc6ea5-afaa-4542-bfc3-eb63f11d33b3"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
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


This is a multi-part message in MIME format.

------=_NextPartTM-000-e9fc6ea5-afaa-4542-bfc3-eb63f11d33b3
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Hi List,

I am having a problem abt IPtables Logging.
The LOG target logs the messages to a particular file say =
/var/log/messages depending on the entries in syslog.conf. Now my =
problem is, i want to log messages in some other special file. Or i can =
say, a process is running which will receive all the LOg messages and =
will store it. I was thinking abt the sol for this. I went thro the code =
of iptables Logging in extensions folder. There are files like =
libipt_LOG.c where we are having print statements. So is it fine if =
those statements gets replaced with the api i will provide for logging =
in some special file. If it is, Then i think i have to write the patch =
for it.( And i think this patch is for iptables in usr mode only).=20

If it is not okay, Then i think i have to provide a new target which =
will do these things. But in that case, i don't know how i can do this.

Plz give ur suggestions in both the cases.

Thanks & Regards.
Amit.

------=_NextPartTM-000-e9fc6ea5-afaa-4542-bfc3-eb63f11d33b3
Content-Type: text/plain;
	name="Wipro_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="Wipro_Disclaimer.txt"

**************************Disclaimer**************************************************    
 
 Information contained in this E-MAIL being proprietary to Wipro Limited is 'privileged' 
and 'confidential' and intended for use only by the individual or entity to which it is 
addressed. You are notified that any use, copying or dissemination of the information 
contained in the E-MAIL in any manner whatsoever is strictly prohibited.

****************************************************************************************

------=_NextPartTM-000-e9fc6ea5-afaa-4542-bfc3-eb63f11d33b3--
