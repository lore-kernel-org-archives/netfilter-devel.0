From: Steve Hill <steve-5X2ZMFkmWHHQXOPxS62xeg@public.gmane.org>
Subject: memory leak related to bridging, conntrack and frags in 2.6.0
Date: Fri, 12 Dec 2003 19:55:55 +0000 (GMT)
Sender: ebtables-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <Pine.LNX.4.44.0312121948321.8670-200000@sorbus2.navaho>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-863298270-1071258955=:8670"
Return-path: <ebtables-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
To: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
   <ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>,
   <netfilter-devel-wool9L35kiczKOhml7GhPkB+6BGkLq7r@public.gmane.org>
Errors-To: ebtables-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5utDmRdBvX5/5ji9XKYC2TYK4Io4DoRGLOrNAH6kLmebB@public.gmane.org>
List-Post: <mailto:ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5utDmRdBvX5/5lLLH9aP38KF1pqr+6INuaA@public.gmane.org>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5utDmRdBvX5/5R9m/fhtKvoLKtGCp0j7rLg@public.gmane.org>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=ebtables-devel>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime-oOUblnuQwHKola3qYQ6TW/IULO3mGbRi9nwVQlTi/Pw@public.gmane.org for more info.

--8323328-863298270-1071258955=:8670
Content-Type: TEXT/PLAIN; charset=US-ASCII


Sorry for the cross-post - I thought this would be of interest to all the 
lists and also wasn't sure where the best people to help hang out.

With both conntrack and bridging turned on in the 2.6.0test11 kernel, 
sending fragmented packets over the bridge reveals a memory leak 
(specifically, forwarding packets from any interface to a bridge).  The 
memory that is leaking seems to be being allocated on line 299 on 
net/bridge/br_netfilter.c:

        if ((nf_bridge = nf_bridge_alloc(skb)) == NULL)
                return NF_DROP;
  
Only the first fragment gets freed later on.

The patch attached fixes the problem by freeing nf_bridge when the 
packets are defragmented, however I am sure this is not the right place 
to do this.  Where would the skb's for the fragments usually get freed?

-- 

- Steve Hill
Senior Software Developer                        Email: steve-5X2ZMFkmWHHQXOPxS62xeg@public.gmane.org
Navaho Technologies Ltd.                           Tel: +44-870-7034015

        ... Alcohol and calculus don't mix - Don't drink and derive! ...


--8323328-863298270-1071258955=:8670
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="bridge-memleak.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0312121955550.8670-P6xViTKO+D9l6dsDrSIFUQ@public.gmane.org>
Content-Description: 
Content-Disposition: attachment; filename="bridge-memleak.patch"

ZGlmZiAtdXJOIGxpbnV4LTIuNi4wLXRlc3QxMS52YW5pbGxhL25ldC9pcHY0
L2lwX2ZyYWdtZW50LmMgbGludXgtMi42LjAtdGVzdDExLmJyaWRnZS9uZXQv
aXB2NC9pcF9mcmFnbWVudC5jDQotLS0gbGludXgtMi42LjAtdGVzdDExLnZh
bmlsbGEvbmV0L2lwdjQvaXBfZnJhZ21lbnQuYwkyMDAzLTEyLTEyIDE5OjI3
OjA3LjAwMDAwMDAwMCArMDAwMA0KKysrIGxpbnV4LTIuNi4wLXRlc3QxMS5i
cmlkZ2UvbmV0L2lwdjQvaXBfZnJhZ21lbnQuYwkyMDAzLTEyLTEyIDE5OjQy
OjUwLjAwMDAwMDAwMCArMDAwMA0KQEAgLTU5Miw2ICs1OTIsMTIgQEANCiAJ
YXRvbWljX3N1YihoZWFkLT50cnVlc2l6ZSwgJmlwX2ZyYWdfbWVtKTsNCiAN
CiAJZm9yIChmcD1oZWFkLT5uZXh0OyBmcDsgZnAgPSBmcC0+bmV4dCkgew0K
KyNpZmRlZiBDT05GSUdfQlJJREdFX05FVEZJTFRFUg0KKwkJaWYgKGZwLT5u
Zl9icmlkZ2UpIHsNCisJCQluZl9icmlkZ2VfcHV0KGZwLT5uZl9icmlkZ2Up
Ow0KKwkJCWZwLT5uZl9icmlkZ2UgPSBOVUxMOw0KKwkJfTsNCisjZW5kaWYN
CiAJCWhlYWQtPmRhdGFfbGVuICs9IGZwLT5sZW47DQogCQloZWFkLT5sZW4g
Kz0gZnAtPmxlbjsNCiAJCWlmIChoZWFkLT5pcF9zdW1tZWQgIT0gZnAtPmlw
X3N1bW1lZCkNCg==
--8323328-863298270-1071258955=:8670--



-------------------------------------------------------
This SF.net email is sponsored by: IBM Linux Tutorials.
Become an expert in LINUX or just sharpen your skills.  Sign up for IBM's
Free Linux Tutorials.  Learn everything from the bash shell to sys admin.
Click now! http://ads.osdn.com/?ad_id=1278&alloc_id=3371&op=click
