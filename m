From: Richard Bishop <r.j.bishop@ex.ac.uk>
Subject: Re: libipq/payload doubt
Date: Wed, 19 May 2004 11:02:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1084960972.40ab30cc0af1c@chloride.lan.uchange.co.uk>
References: <20040519062032.GA32401@maluco.com.br>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="-MOQ1084960971bc14a5d76751848cc64b0c467226061d"
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ulysses Almeida <munky@maluco.com.br>
In-Reply-To: <20040519062032.GA32401@maluco.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This message is in MIME format.

---MOQ1084960971bc14a5d76751848cc64b0c467226061d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit


Hi,

Quoting Ulysses Almeida <munky@maluco.com.br>:

> This daemon, just look for tcp packges, and print
> some infos on stdout. It's printing IP src and dst address, and now
> i'm trying to print src and dst TCP port address, but, I don't know
> why, when I print those info, I can't get expected ports. port 80 is
> showed as 20480.
> 
> Do I have to convert something before printing in human readable format?


As one of the other guys said, the port discrepancy is an 'endian' problem.

Try this code (attached) - I had exactly the same problem when I first started
playing around with ipq.  Bear in mind that I've skipped out all of the code for
setting up the ipq handle etc, though if you've had it recieving packets then
you'll have this already.

Good luck!


Richard

-- 
Richard Bishop
Third Year Undergraduate
Department of Computer Science
University of Exeter. UK


---MOQ1084960971bc14a5d76751848cc64b0c467226061d
Content-Type: application/octet-stream; name="ipq_test"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="ipq_test"

CgojaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyLmg+CiNpbmNsdWRlIDxsaWJpcHEvbGliaXBxLmg+
CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8bGludXgvaXAuaD4KI2luY2x1ZGUgPG5ldGlu
ZXQvaW4uaD4KI2luY2x1ZGUgPGxpbnV4L3RjcC5oPgoKCmludCBtYWluKGludCBhcmdjLCBjaGFy
ICoqYXJndikgewoKCXN0cnVjdCBpcHFfaGFuZGxlICpoOwoJdW5zaWduZWQgY2hhciBidWZmZXJb
QlVGU0laRV07CgoJc3RydWN0IGlwaGRyICppcGg7CglzdHJ1Y3QgdGNwaGRyICp0Y3A7CgkKCQoJ
CgkKCS8qIC4uLi4gQ29kZSBmb3Igc2V0dGluZyB1cCBpcF9xdWV1ZSBjb25uZWN0aW9uIGV0YyBo
ZXJlIC4uLiAqLwoJCgoJZG8gewoJCgkJc3RhdHVzID0gaXBxX3JlYWQoaCwgYnVmZmVyLCBCVUZT
SVpFLCAwKTsKCQkKCQlpZiAoc3RhdHVzIDwwKSB7CgkJCXByaW50ZigiU29tZXRoaW5nIHdlbnQg
d3JvbmcgcmVhZGluZyBkYXRhXG4iKTsKCQkJY29udGludWU7CgkJfQoJCgkJc3dpdGNoKGlwcV9t
ZXNzYWdlX3R5cGUoYnVmZmVyKSkgewoJCQkKCQkJLyogSWYgdGhpcyBpcyBhbiBlcnJvciBtZXNz
YWdlICovCgkJCWNhc2UgTkxNU0dfRVJST1I6IHsKCQkJCXByaW50ZigiSXBxIHNhaWQgc29tZXRo
aW5nIGJhZC4gRXJyb3IgbnVtYmVyICVkXG4iLGlwcV9nZXRfbXNnZXJyKGJ1ZmZlcikpOwoJCQl9
CgkJCQoJCQkvKiBPdGhlcndpc2UgdGhpcyB3aWxsIGJlIGEgZGF0YSBwYWNrZXQgKi8KCQkJY2Fz
ZSBJUFFNX1BBQ0tFVDogewoJCQkJCgkJCQlwcmludGYoIkdvdCBhIHBhY2tldCFcbiIpOwoJCQkJ
CgkJCQlpcHFfcGFja2V0X21zZ190ICptZXNzID0gaXBxX2dldF9wYWNrZXQoYnVmZmVyKTsKCQkJ
CQoJCQkJCgkJCQkvKiBPYnRhaW4gYm90aCBhIGlwIGFuZCB0Y3AgaGVhZGVyIGZvciB0aGlzIHBh
Y2tldCBieSBjYXN0aW5nIGl0IGludG8gdGhlIHJlbGV2YW50IHN0cnVjdHVyZXMgKi8KCQkJCWlw
aCA9IChzdHJ1Y3QgaXBoZHIqKW1lc3MtPnBheWxvYWQ7CgkJCQl0Y3AgPSAoc3RydWN0IHRjcGhk
ciopICgodm9pZCAqKSBpcGggKyBpcGgtPmlobCo0KTsKCQkJCQoJCQkJCgkJCQkvKiBHZXQgdGhl
IHNvdXJjZSBhbmQgZGVzdGluYXRpb24gcG9ydHMgZm9yIHRoaXMgY29ubmVjdGlvbiBmcm9tIHRo
ZSB0Y3AgaGVhZGVyICovCgkJCQlfX3UxNiBzcG9ydCA9IG50b2hzKCB0Y3AtPnNvdXJjZSk7CgkJ
CQlfX3UxNiBkcG9ydCA9IG50b2hzKCB0Y3AtPmRlc3QpOwoJCQkJCgkJCQkKCQkJCXByaW50Zigi
U291cmNlIEFkZHI6ICVzXG4iLGluZXRfbnRvYShpcGgtPnNhZGRyKSk7CgkJCQlwcmludGYoIkRl
c3QgQWRkcjogJXNcbiIsaW5ldF9udG9hKGlwaC0+ZGFkZHIpKTsKCQkJCXByaW50ZigiU291cmNl
IFBvcnQ6ICVkXG4iLHNwb3J0KTsKCQkJCXByaW50ZigiRGVzdGluIFBvcnQ6ICVkXG5cbiIsZHBv
cnQpOwoJCQkJCgkJCQkKCQkJfQoJCQkKCQl9CgkJCgl9CgkKfQ==

---MOQ1084960971bc14a5d76751848cc64b0c467226061d--
