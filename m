From: Michael Carmody <michaelc@mikeit.com.au>
Subject: netfilter h323 helper extension
Date: Tue, 27 Jul 2004 16:50:36 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407271650.36835.michaelc@mikeit.com.au>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8sfBBxT209eAHvj"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_8sfBBxT209eAHvj
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It seems that Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> has a very tight 
spam filter and has rejected all my mails so far.

Anyway posting this to list to see if anyone else can help...



Trying this out for a H.323 Interop project between cisco and 3com VoIP gear.

Without any helper and just basic port redirection I get phones ringing but of 
course since the H.225 packet is not being mangled the systems try to connect 
to the wrong IP.

With your ip_conntrack_h323 and ip_nat_h323 modules loaded I get non-function.

Specifically there is one packet that is dissappearing. Between MS netmeeting 
and our 3com system, it is the second packet after the Q.931 Short frame, 
specifically from the caller to the callee. TCP packet from random port to 
port 1720 on callee's system. It appears on the external interface of the 
firewall but does not re-appear in the internal interface.

I have attached 2 ethereal capture files.

Any Help you could offer would be much appreciated

Debugging turned on gave:

Jul 27 16:01:42 adam kernel: ASSERT ip_conntrack_core.c:631 &ip_conntrack_lock 
not readlocked
Jul 27 16:04:40 adam kernel: ct_h225_help: help entered 
218.214.140.63:1086->218.214.139.134:1720
Jul 27 16:04:40 adam kernel: ct_h225_help: Conntrackinfo = 2
Jul 27 16:04:40 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:04:40 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:04:40 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:04:40 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:04:40 adam kernel: ct_h225_help: help entered 
172.16.34.201:1720->218.214.140.63:1086
Jul 27 16:04:40 adam kernel: ct_h225_help: tcplen = 28
Jul 27 16:04:40 adam kernel: nat_h323: dir REPLY at hook PREROUTING
Jul 27 16:04:40 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:04:40 adam kernel: nat_h323: dir REPLY at hook POSTROUTING
Jul 27 16:04:40 adam kernel: nat_h323: Not touching dir REPLY at hook 
POSTROUTING
Jul 27 16:04:40 adam kernel: ct_h225_help: help entered 
218.214.140.63:1086->218.214.139.134:1720
Jul 27 16:04:40 adam kernel: ct_h225_help: tcplen = 20
Jul 27 16:04:40 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:04:40 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:04:40 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:04:40 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:04:40 adam kernel: ct_h225_help: help entered 
218.214.140.63:1086->218.214.139.134:1720
Jul 27 16:04:40 adam kernel: ct_h225_help: tcplen = 24
Jul 27 16:04:40 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:04:40 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:04:40 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:04:40 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:04:40 adam kernel: ct_h225_help: help entered 
172.16.34.201:1720->218.214.140.63:1086
Jul 27 16:04:40 adam kernel: ct_h225_help: tcplen = 20
Jul 27 16:04:40 adam kernel: nat_h323: dir REPLY at hook PREROUTING
Jul 27 16:04:40 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:04:40 adam kernel: nat_h323: dir REPLY at hook POSTROUTING
Jul 27 16:04:40 adam kernel: nat_h323: Not touching dir REPLY at hook 
POSTROUTING
Jul 27 16:04:41 adam kernel: ct_h225_help: help entered 
218.214.140.63:1086->218.214.139.134:1720
Jul 27 16:04:41 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:04:41 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:04:41 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:04:44 adam kernel: ct_h225_help: help entered 
218.214.140.63:1086->218.214.139.134:1720
Jul 27 16:04:44 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:04:44 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:04:44 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:04:49 adam kernel: ct_h225_help: help entered 
218.214.140.63:1086->218.214.139.134:1720
Jul 27 16:04:49 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:04:49 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:04:49 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:05:01 adam kernel: ct_h225_help: help entered 
218.214.140.63:1086->218.214.139.134:1720
Jul 27 16:05:01 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:05:01 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:05:01 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:05:10 adam kernel: ct_h225_help: help entered 
218.214.140.63:1086->218.214.139.134:1720
Jul 27 16:05:10 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:05:10 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:05:24 adam kernel: ct_h225_help: help entered 
218.214.140.63:1086->218.214.139.134:1720
Jul 27 16:05:24 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:05:24 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:05:24 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:06:11 adam kernel: ct_h225_help: help entered 
218.214.140.63:1086->218.214.139.134:1720
Jul 27 16:06:11 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:06:11 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:06:11 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING


And a second debugging output :

Jul 27 16:18:04 adam kernel: ct_h225_help: help entered 
218.214.140.63:1094->218.214.139.134:1720
Jul 27 16:18:04 adam kernel: ct_h225_help: Conntrackinfo = 2
Jul 27 16:18:04 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:18:04 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:18:04 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:18:04 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:18:04 adam kernel: ct_h225_help: help entered 
172.16.34.201:1720->218.214.140.63:1094
Jul 27 16:18:04 adam kernel: ct_h225_help: tcplen = 28
Jul 27 16:18:04 adam kernel: nat_h323: dir REPLY at hook PREROUTING
Jul 27 16:18:04 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:18:04 adam kernel: nat_h323: dir REPLY at hook POSTROUTING
Jul 27 16:18:04 adam kernel: nat_h323: Not touching dir REPLY at hook 
POSTROUTING
Jul 27 16:18:05 adam kernel: ct_h225_help: help entered 
218.214.140.63:1094->218.214.139.134:1720
Jul 27 16:18:05 adam kernel: ct_h225_help: tcplen = 20
Jul 27 16:18:05 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:18:05 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:18:05 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:18:05 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:18:05 adam kernel: ct_h225_help: help entered 
218.214.140.63:1094->218.214.139.134:1720
Jul 27 16:18:05 adam kernel: ct_h225_help: tcplen = 24
Jul 27 16:18:05 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:18:05 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:18:05 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:18:05 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:18:05 adam kernel: ct_h225_help: help entered 
172.16.34.201:1720->218.214.140.63:1094
Jul 27 16:18:05 adam kernel: ct_h225_help: tcplen = 20
Jul 27 16:18:05 adam kernel: nat_h323: dir REPLY at hook PREROUTING
Jul 27 16:18:05 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:18:05 adam kernel: nat_h323: dir REPLY at hook POSTROUTING
Jul 27 16:18:05 adam kernel: nat_h323: Not touching dir REPLY at hook 
POSTROUTING
Jul 27 16:18:05 adam kernel: ct_h225_help: help entered 
218.214.140.63:1094->218.214.139.134:1720
Jul 27 16:18:05 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:18:05 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:18:05 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:18:05 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:18:05 adam kernel: h323_signal_address_fixup: no yes
Jul 27 16:18:05 adam kernel: h323_signal_address_fixup: offsets 3 + 6  and 110 
+ 6 in 252
Jul 27 16:18:05 adam kernel: tuple d8790b10: 6 218.214.140.63:1094 -> 
218.214.139.134:1720
Jul 27 16:18:05 adam kernel: tuple d8790b2c: 6 172.16.34.201:1720 -> 
218.214.140.63:1094
Jul 27 16:18:05 adam kernel: h323_signal_address_fixup: original caller
Jul 27 16:18:05 adam kernel: h323_signal_address_fixup: original callee
Jul 27 16:18:05 adam kernel: h323_signal_address_fixup: orig dest   IP:port 
218.214.139.134:1720
Jul 27 16:18:05 adam kernel: h323_signal_address_fixup:  new dest   IP:port 
172.16.34.201:1720
Jul 27 16:18:08 adam kernel: ct_h225_help: help entered 
218.214.140.63:1094->218.214.139.134:1720
Jul 27 16:18:08 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:18:08 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:18:08 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:18:08 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:18:08 adam kernel: h323_signal_address_fixup: no yes
Jul 27 16:18:08 adam kernel: h323_signal_address_fixup: offsets 3 + 6  and 110 
+ 6 in 252
Jul 27 16:18:08 adam kernel: tuple d8790b10: 6 218.214.140.63:1094 -> 
218.214.139.134:1720
Jul 27 16:18:08 adam kernel: tuple d8790b2c: 6 172.16.34.201:1720 -> 
218.214.140.63:1094
Jul 27 16:18:08 adam kernel: h323_signal_address_fixup: original caller
Jul 27 16:18:08 adam kernel: h323_signal_address_fixup: original callee
Jul 27 16:18:08 adam kernel: h323_signal_address_fixup: orig dest   IP:port 
218.214.139.134:1720
Jul 27 16:18:08 adam kernel: h323_signal_address_fixup:  new dest   IP:port 
172.16.34.201:1720
Jul 27 16:18:14 adam kernel: ct_h225_help: help entered 
218.214.140.63:1094->218.214.139.134:1720
Jul 27 16:18:14 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:18:14 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:18:14 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:18:14 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:18:14 adam kernel: h323_signal_address_fixup: no yes
Jul 27 16:18:14 adam kernel: h323_signal_address_fixup: offsets 3 + 6  and 110 
+ 6 in 252
Jul 27 16:18:14 adam kernel: tuple d8790b10: 6 218.214.140.63:1094 -> 
218.214.139.134:1720
Jul 27 16:18:14 adam kernel: tuple d8790b2c: 6 172.16.34.201:1720 -> 
218.214.140.63:1094
Jul 27 16:18:14 adam kernel: h323_signal_address_fixup: original caller
Jul 27 16:18:14 adam kernel: h323_signal_address_fixup: original callee
Jul 27 16:18:14 adam kernel: h323_signal_address_fixup: orig dest   IP:port 
218.214.139.134:1720
Jul 27 16:18:14 adam kernel: h323_signal_address_fixup:  new dest   IP:port 
172.16.34.201:1720
Jul 27 16:18:26 adam kernel: ct_h225_help: help entered 
218.214.140.63:1094->218.214.139.134:1720
Jul 27 16:18:26 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:18:26 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:18:26 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:18:26 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:18:26 adam kernel: h323_signal_address_fixup: no yes
Jul 27 16:18:26 adam kernel: h323_signal_address_fixup: offsets 3 + 6  and 110 
+ 6 in 252
Jul 27 16:18:26 adam kernel: tuple d8790b10: 6 218.214.140.63:1094 -> 
218.214.139.134:1720
Jul 27 16:18:26 adam kernel: tuple d8790b2c: 6 172.16.34.201:1720 -> 
218.214.140.63:1094
Jul 27 16:18:26 adam kernel: h323_signal_address_fixup: original caller
Jul 27 16:18:26 adam kernel: h323_signal_address_fixup: original callee
Jul 27 16:18:26 adam kernel: h323_signal_address_fixup: orig dest   IP:port 
218.214.139.134:1720
Jul 27 16:18:26 adam kernel: h323_signal_address_fixup:  new dest   IP:port 
172.16.34.201:1720
Jul 27 16:18:35 adam kernel: ct_h225_help: help entered 
218.214.140.63:1094->218.214.139.134:1720
Jul 27 16:18:35 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:18:35 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:18:35 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:18:35 adam kernel: h323_signal_address_fixup: no no
Jul 27 16:18:47 adam kernel: ct_h225_help: help entered 
218.214.140.63:1094->218.214.139.134:1720
Jul 27 16:18:47 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:18:47 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:18:47 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:18:47 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:18:47 adam kernel: h323_signal_address_fixup: no yes
Jul 27 16:18:47 adam kernel: h323_signal_address_fixup: offsets 3 + 6  and 110 
+ 6 in 298
Jul 27 16:18:47 adam kernel: tuple d8790b10: 6 218.214.140.63:1094 -> 
218.214.139.134:1720
Jul 27 16:18:47 adam kernel: tuple d8790b2c: 6 172.16.34.201:1720 -> 
218.214.140.63:1094
Jul 27 16:18:47 adam kernel: h323_signal_address_fixup: original caller
Jul 27 16:18:47 adam kernel: h323_signal_address_fixup: original callee
Jul 27 16:18:47 adam kernel: h323_signal_address_fixup: orig dest   IP:port 
218.214.139.134:1720
Jul 27 16:18:47 adam kernel: h323_signal_address_fixup:  new dest   IP:port 
172.16.34.201:1720
Jul 27 16:19:32 adam kernel: ct_h225_help: help entered 
218.214.140.63:1094->218.214.139.134:1720
Jul 27 16:19:32 adam kernel: ct_h225_help: destCallSignalAddress 
218.214.139.134
Jul 27 16:19:32 adam kernel: nat_h323: dir ORIG at hook PREROUTING
Jul 27 16:19:32 adam kernel: nat_h323: Not touching dir ORIG at hook 
PREROUTING
Jul 27 16:19:32 adam kernel: nat_h323: dir ORIG at hook POSTROUTING
Jul 27 16:19:32 adam kernel: h323_signal_address_fixup: no yes
Jul 27 16:19:32 adam kernel: h323_signal_address_fixup: offsets 3 + 6  and 110 
+ 6 in 298
Jul 27 16:19:32 adam kernel: tuple d8790b10: 6 218.214.140.63:1094 -> 
218.214.139.134:1720
Jul 27 16:19:32 adam kernel: tuple d8790b2c: 6 172.16.34.201:1720 -> 
218.214.140.63:1094
Jul 27 16:19:32 adam kernel: h323_signal_address_fixup: original caller
Jul 27 16:19:32 adam kernel: h323_signal_address_fixup: original callee
Jul 27 16:19:32 adam kernel: h323_signal_address_fixup: orig dest   IP:port 
218.214.139.134:1720
Jul 27 16:19:32 adam kernel: h323_signal_address_fixup:  new dest   IP:port 
172.16.34.201:1720


-Michael Carmody









--Boundary-00=_8sfBBxT209eAHvj
Content-Type: application/octet-stream;
  name="dump-int.h323"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dump-int.h323"

1MOyoQIABAAAAAAAAAAAAP//AAABAAAANdkFQaQEAwA8AAAAPAAAAP///////wBAY9PtbggGAAEI
AAYEAAEAQGPT7W6sECLJAAAAAAAArBAiAQAAAAAAAAAAAAAAAAAAAAAAADXZBUHJBAMAKgAAACoA
AAAAQGPT7W4AQPRCN2MIBgABCAAGBAACAED0QjdjrBAiAQBAY9PtbqwQIslQ2QVBPQQEAD4AAAA+
AAAAAEBj0+1uAED0QjdjCABFAAAwzZVAAH0G+kLa1ow/rBAiyQgkBrgq+rJUAAAAAHAC//Bh3AAA
AgQE7AEBBAJQ2QVBIAUEAD4AAAA+AAAAAED0QjdjAEBj0+1uCABFAAAwi3FAAIAGOWesECLJ2taM
Pwa4CCQ4S0BHKvqyVXASROijeQAAAgQFtAEBBAJR2QVBabMBADYAAAA2AAAAAEBj0+1uAED0Qjdj
CABFAAAozcxAAH0G+hPa1ow/rBAiyQgkBrgq+rJVOEtASFAQ//AVNQAAUdkFQWHLAQA6AAAAOgAA
AABAY9PtbgBA9EI3YwgARQAALM3NQAB9BvoO2taMP6wQIskIJAa4KvqyVThLQEhQGP/wET0AAAMA
AOxR2QVBJQ0EADwAAAA8AAAAAED0QjdjAEBj0+1uCABFAAAoi3JAAIAGOW6sECLJ2taMPwa4CCQ4
S0BIKvqyWVAQROTQPQAAAAAAAAAAbtkFQXCkBAA+AAAAPgAAAABAY9PtbgBA9EI3YwgARQAAMM8K
QAB9BvjN2taMP6wQIskIJgXfK3G3DgAAAABwAv/wXYIAAAIEBOwBAQQCbtkFQTmlBAA8AAAAPAAA
AABA9EI3YwBAY9PtbggARQAAKItzAACABnltrBAiydrWjD8F3wgmAAAAACtxtw9QFAAAiVsAAAAA
AAAAAG/ZBUHd+AIAPgAAAD4AAAAAQGPT7W4AQPRCN2MIAEUAADDPE0AAfQb4xNrWjD+sECLJCCYF
3ytxtw4AAAAAcAL/8F2CAAACBATsAQEEAm/ZBUGf+QIAPAAAADwAAAAAQPRCN2MAQGPT7W4IAEUA
ACiLdAAAgAZ5bKwQIsna1ow/Bd8IJgAAAAArcbcPUBQAAIlbAAAAAAAAAABv2QVBr4MLAD4AAAA+
AAAAAEBj0+1uAED0QjdjCABFAAAwzxhAAH0G+L/a1ow/rBAiyQgmBd8rcbcOAAAAAHAC//BdggAA
AgQE7AEBBAJv2QVBHYYLADwAAAA8AAAAAED0QjdjAEBj0+1uCABFAAAoi3UAAIAGeWusECLJ2taM
PwXfCCYAAAAAK3G3D1AUAACJWwAAAAAAAAAA

--Boundary-00=_8sfBBxT209eAHvj
Content-Type: application/octet-stream;
  name="dump3.h323"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dump3.h323"

1MOyoQIABAAAAAAAAAAAAP//AABxAAAAUNkFQdwDBABAAAAAQAAAAAAAAgAAAAAAAAAAAAAACABF
AAAwzZVAAH4GYb/a1ow/2taLhggkBrgq+rJUAAAAAHAC//DKWAAAAgQE7AEBBAJQ2QVBRgUEAEAA
AABAAAAAAAQCAAAAAAAAAAAAAAAIAEUAADCLcUAAfwai49rWi4ba1ow/BrgIJDhLQEcq+rJVcBJE
6Av2AAACBAW0AQEEAlHZBUFRswEAOAAAADgAAAAAAAIAAAAAAAAAAAAAAAgARQAAKM3MQAB+BmGQ
2taMP9rWi4YIJAa4KvqyVThLQEhQEP/wfbEAAFHZBUFNywEAPAAAADwAAAAAAAIAAAAAAAAAAAAA
AAgARQAALM3NQAB+BmGL2taMP9rWi4YIJAa4KvqyVThLQEhQGP/webkAAAMAAOxR2QVBPQ0EADgA
AAA4AAAAAAQCAAAAAAAAAAAAAAAIAEUAACiLckAAfwai6trWi4ba1ow/BrgIJDhLQEgq+rJZUBBE
5Di6AABR2QVBAXINACABAAAgAQAAAAACAAAAAAAAAAAAAAAIAEUAARDN5UAAfgZgj9rWjD/a1ouG
CCQGuCr6slk4S0BIUBj/8PDcAAAIAkbHBQQDiMClKBBNaWNoYWVsIENhcm1vZHkAfgDJBRCoBgAI
kUoAAgFADgBNAGkAYwBoAGEAZQBsACAAQwBhAHIAbQBvAGQAeSLAtQBTTBZNaWNyb3NvZnSuIE5l
dE1lZXRpbmeuAAMzLjAAANrWi4YGuAAHzneQg/1cRI4Ku1nKiXroAEUMBwAKAAAUCCQRAFvn1T2G
+dNJppXPpQVD6QkBAAEAQLUAU0w8AgAAACgAAAAAAAAAGwAAAIE4QnSEzNIRtOMAoMkNBmAQAAAA
/KwsBqaxUUiGmPk/nhmiQAAAAAAAAAAAVNkFQURxDgAgAQAAIAEAAAAAAgAAAAAAAAAAAAAACABF
AAEQzhRAAH4GYGDa1ow/2taLhggkBrgq+rJZOEtASFAY//Dw3AAACAJGxwUEA4jApSgQTWljaGFl
bCBDYXJtb2R5AH4AyQUQqAYACJFKAAIBQA4ATQBpAGMAaABhAGUAbAAgAEMAYQByAG0AbwBkAHki
wLUAU0wWTWljcm9zb2Z0riBOZXRNZWV0aW5nrgADMy4wAADa1ouGBrgAB853kIP9XESOCrtZyol6
6ABFDAcACgAAFAgkEQBb59U9hvnTSaaVz6UFQ+kJAQABAEC1AFNMPAIAAAAoAAAAAAAAABsAAACB
OEJ0hMzSEbTjAKDJDQZgEAAAAPysLAamsVFIhpj5P54ZokAAAAAAAAAAAFvZBUH3qwoAIAEAACAB
AAAAAAIAAAAAAAAAAAAAAAgARQABEM5rQAB+BmAJ2taMP9rWi4YIJAa4KvqyWThLQEhQGP/w8NwA
AAgCRscFBAOIwKUoEE1pY2hhZWwgQ2FybW9keQB+AMkFEKgGAAiRSgACAUAOAE0AaQBjAGgAYQBl
AGwAIABDAGEAcgBtAG8AZAB5IsC1AFNMFk1pY3Jvc29mdK4gTmV0TWVldGluZ64AAzMuMAAA2taL
hga4AAfOd5CD/VxEjgq7WcqJeugARQwHAAoAABQIJBEAW+fVPYb500mmlc+lBUPpCQEAAQBAtQBT
TDwCAAAAKAAAAAAAAAAbAAAAgThCdITM0hG04wCgyQ0GYBAAAAD8rCwGprFRSIaY+T+eGaJAAAAA
AAAAAABp2QVBkVgKACABAAAgAQAAAAACAAAAAAAAAAAAAAAIAEUAARDO30AAfgZfldrWjD/a1ouG
CCQGuCr6slk4S0BIUBj/8PDcAAAIAkbHBQQDiMClKBBNaWNoYWVsIENhcm1vZHkAfgDJBRCoBgAI
kUoAAgFADgBNAGkAYwBoAGEAZQBsACAAQwBhAHIAbQBvAGQAeSLAtQBTTBZNaWNyb3NvZnSuIE5l
dE1lZXRpbmeuAAMzLjAAANrWi4YGuAAHzneQg/1cRI4Ku1nKiXroAEUMBwAKAAAUCCQRAFvn1T2G
+dNJppXPpQVD6QkBAAEAQLUAU0w8AgAAACgAAAAAAAAAGwAAAIE4QnSEzNIRtOMAoMkNBmAQAAAA
/KwsBqaxUUiGmPk/nhmiQAAAAAAAAAAAbtkFQe6jBABAAAAAQAAAAAAAAgAAAAAAAAAAAAAACABF
AAAwzwpAAH4GYEra1ow/2taLhggmBd8rcbcOAAAAAHAC//DF/gAAAgQE7AEBBAJu2QVBVaUEADgA
AAA4AAAAAAQCAAAAAAAAAAAAAAAIAEUAACiLcwAAfwbi6drWi4ba1ow/Bd8IJgAAAAArcbcPUBQA
APHXAABu2QVBMcsEAGYAAABmAAAAAAACAAAAAAAAAAAAAAAIAEUAAFbPC0AAfgZgI9rWjD/a1ouG
CCQGuCr6s0E4S0BIUBn/8NCfAAADAAAuCAJGx1oIAwAA5n4AHQUFgAYACJFKAAIBEQBb59U9hvnT
SaaVz6UFQ+kJb9kFQZn4AgBAAAAAQAAAAAAAAgAAAAAAAAAAAAAACABFAAAwzxNAAH4GYEHa1ow/
2taLhggmBd8rcbcOAAAAAHAC//DF/gAAAgQE7AEBBAJv2QVBt/kCADgAAAA4AAAAAAQCAAAAAAAA
AAAAAAAIAEUAACiLdAAAfwbi6NrWi4ba1ow/Bd8IJgAAAAArcbcPUBQAAPHXAABv2QVBUYMLAEAA
AABAAAAAAAACAAAAAAAAAAAAAAAIAEUAADDPGEAAfgZgPNrWjD/a1ouGCCYF3ytxtw4AAAAAcAL/
8MX+AAACBATsAQEEAm/ZBUE6hgsAOAAAADgAAAAABAIAAAAAAAAAAAAAAAgARQAAKIt1AAB/BuLn
2taLhtrWjD8F3wgmAAAAACtxtw9QFAAA8dcAAA==

--Boundary-00=_8sfBBxT209eAHvj--
