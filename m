From: "=?ISO-8859-1?Q?Omar_A=EFt_Mous?=" <omar.aitmous@gmail.com>
Subject: Connection tracking synchronization module
Date: Wed, 16 Aug 2006 11:01:32 +0200
Message-ID: <e084545e0608160201v1a2420f8mfca0551ce16c9024@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_86843_1448259.1155718892010"
Cc: risk_colta@hotmail.com, sebastien.wacquiez@enix.fr, smagghue@gmail.com,
	jp@enix.org
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

------=_Part_86843_1448259.1155718892010
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This is a kernel module to allow real-time synchronization of connection
tracking tables between two linux routers. It will be useful for people willing
to achieve high availability of stateful firewalls, or NAT routers. It's our
first attempt at kernel hacking, so there is probably many errors and things to
fix, but it Works For Us (TM). you can even test it without recompiling your
kernel. see attached README file for the gory details. You would be so kind to
cc: us when replying ! :)
This code is similar (feature-wise) to the ct_sync projet. It has the
advantages of offering multi-master mode, and requiring minimal
patching of your kernel (or even no patching at all). On the cons
side, it is technologically less evolved since it does not use de new
nfnetlink sockets.
We would like to know if the ct_sync project is still maintained and
if this module interests you.
Latest version can be found here :
http://enix.fr/projects/syntrack/browser/tarballs/revision-90.tar.gz?format=raw
Or here for future releases :
http://enix.fr/projects/syntrack/browser/tarballs

------=_Part_86843_1448259.1155718892010
Content-Type: application/octet-stream; name=README
Content-Transfer-Encoding: base64
X-Attachment-Id: f_eqxgfjz3
Content-Disposition: attachment; filename="README"

U3ludHJhY2sgbW9kdWxlCj09PT09PT09PT09PT09PQoKVGhpcyBrZXJuZWwgbW9kdWxlIGNhbiBi
ZSB1c2VkIHRvIGtlZXAgdGhlIGNvbm5lY3Rpb24gdHJhY2tpbmcgdGFibGVzIG9mIHR3bwpMaW51
eCByb3V0ZXJzIGluIHN5bmMuIFRoZSBtb2R1bGUgaXRzZWxmIHdpbGwgYWxsb3cgcmVhZGluZyAm
IHdyaXRpbmcgdGhlCmNvbm50cmFjayB0YWJsZSB0aHJ1IGEgY2hhcmFjdGVyIGRldmljZSAoL2Rl
di9zeW50cmFjayA7IHNob3VsZCBiZSBjcmVhdGVkCmF1dG9tYXRpY2FsbHkgd2l0aCB5b3VyIGF2
ZXJhZ2UgdWRldiBjb25maWd1cmF0aW9uKS4gVG8gc3luY2hyb25pemUgdGhlIHRhYmxlCndpdGgg
YW5vdGhlciByb3V0ZXIvZmlyZXdhbGwsIHlvdSB3aWxsIGFsc28gbmVlZCBhIHVzZXJsYW5kIHRv
b2wuCgpUbyBjb21waWxlIDoKSWYgdGhlIGtlcm5lbCBoYXMgYmVlbiBwYXRjaGVkIGFjY29yZGlu
ZyB0byB0aGUgY2hhbmdlcyBkZXNjcmliZWQgYmVsb3csCm1ha2UgRVhUUkFfQ0ZMQUdTPS1ETkFU
X0VYUE9SVEVECm90aGVyd2lzZSwKbWFrZQoKVG8gZXhlY3V0ZSA6Ck9uY2UgY29tcGlsZWQsIHlv
dSdsbCBmaW5kIGluIHRoZSBzb3VyY2UgZGlyZWN0b3J5IGEgZmlsZSBuYW1lZCAnc3ludHJhY2su
a28nIApjb3JyZXNwb25kaW5nIHRvIHRoZSBtb2R1bGUgOyBpbnNtb2QgaXQgaW50byB5b3VyIHJ1
bm5pbmcga2VybmVsLiBJdCBzaG91bGQKY3JlYXRlIHRoZSAvZGV2L3N5bnRyYWNrIGRldmljZS4K
VG8gdGVzdCB0aGUgd2hvbGUgc3luY2hyb25pemF0aW9uIHByb2Nlc3MsIHlvdSB3aWxsIG5lZWQg
dHdvIExpbnV4IHJvdXRlcnMsCndoaWNoIHNob3VsZCBydW4gdGhlIHNhbWUga2VybmVsIChubyB0
ZXN0aW5nIGhhcyBiZWVuIGRvbmUgeWV0IHdpdGggZGlmZmVyZW50Cmtlcm5lbCB2ZXJzaW9ucyA7
IGl0IHNob3VsZCB3b3JrIGFzIGxvbmcgYXMgdGhlIHNhbWUgY29ubnRyYWNrIG9wdGlvbnMgaGF2
ZQpiZWVuIHNldCBvbiBib3RoIHNpZGVzKS4KUnVuICJzeW50cmFja19zZW5kIGJhY2t1cC5pcCIg
b24gdGhlICJtYWluIiByb3V0ZXIsIGFuZCAic3ludHJhY2tfcmVjdiBtYWluLmlwIgpvbiB0aGUg
ImJhY2t1cCIgcm91dGVyLiBGcm9tIG5vdyBvbiwgdGhlIC9wcm9jL25ldC9pcF9jb25udHJhY2sg
c3BlY2lhbCBmaWxlCm9uIHRoZSBiYWNrdXAgcm91dGVyIHdpbGwgcmVmbGVjdCB0aGUgY2hhbmdl
cyBvZiB0aGUgc2FtZSBmaWxlIG9uIHRoZSBtYWluCnJvdXRlci4KCklmIHlvdSB3YW50IE5BVCB0
byB3b3JrIGNvcnJlY3RseSwgeW91IHNob3VsZCBhcHBseSB0aGUgZm9sbG93aW5nIGNoYW5nZXMg
dG8KeW91ciBrZXJuZWwgc291cmNlcyA6CgkKRmlsZSA6IGlwX25hdF9jb3JlLmMgKG5ldC9pcHY0
L25ldGZpbHRlcikKbGluZSA0NyA6IC8qc3RhdGljICovdW5zaWduZWQgaW50IGlwX25hdF9odGFi
bGVfc2l6ZTsKbGluZSA0OSA6IC8qc3RhdGljICovc3RydWN0IGxpc3RfaGVhZCAqYnlzb3VyY2U7
CgpuZXcgZXhwb3J0ZWQgc3ltYm9scyA6CkVYUE9SVF9TWU1CT0xfR1BMKGlwX25hdF9odGFibGVf
c2l6ZSk7CkVYUE9SVF9TWU1CT0xfR1BMKGlwX25hdF9sb2NrKTsKRVhQT1JUX1NZTUJPTF9HUEwo
Ynlzb3VyY2UpOwoKWW91IGNhbiBhbHNvIGRvIHRoaXMgdXNpbmcgdGhlIHBhdGNoIGZpbGUgbmF0
LmRpZmYgOgoJcGF0Y2ggLXAxIDwgbmF0LmRpZmYKYXQgdGhlIGxpbnV4IGtlcm5lbCBzb3VyY2Ug
ZGlyZWN0b3J5LgpUbyB1bnBhdGNoLCBqdXN0IHRyeSA6CglwYXRjaCAtcDEgLVIgPCBuYXQuZGlm
ZgphdCB0aGUgc2FtZSBkaXJlY3RvcnkuCldpdGhvdXQgdGhvc2UgY2hhbmdlcywgc3luY2hyb25p
emF0aW9uIHdpdGhvdXQgTkFUIHdpbGwgd29yayA7IHVzYWdlIG9mIE5BVAp3aWxsIHlpZWxkIHVu
cHJlZGljdGFibGUgcmVzdWx0cyBob3dldmVyLgoK
------=_Part_86843_1448259.1155718892010--
